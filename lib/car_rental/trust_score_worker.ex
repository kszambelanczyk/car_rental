defmodule CarRental.TrustScoreWorker do
  @moduledoc false
  use Oban.Worker, queue: :default, max_attempts: 1

  import Ecto.Query, warn: false

  alias CarRental.Clients
  alias CarRental.Repo
  alias CarRental.TrustScore
  alias CarRental.TrustScore.Params
  alias CarRental.TrustScoreScheduler

  require Logger

  @impl true
  def perform(%{args: _args}) do
    params_chunk = TrustScoreScheduler.pop_params_chunk()
    calculate_params(params_chunk)
  end

  # delay to handle no more than 10 requests per minute
  @delay 7

  defp calculate_params([_ | _] = params_chunk) do
    dbg("Calculating scores for #{length(params_chunk)} params")

    %{} |> __MODULE__.new(schedule_in: @delay) |> Oban.insert()

    case TrustScore.calculate_score(%Params{clients: params_chunk}) do
      scores when is_list(scores) ->
        save_scores(scores)

      error ->
        dbg("Error calculating scores: #{inspect(error)}")
        refill_params(params_chunk)
        error
    end
  end

  defp calculate_params(_), do: :ok

  defp save_scores(scores) do
    Enum.each(scores, fn score ->
      params = %Clients.Params{client_id: score.id, score: score.score}
      Clients.save_score_for_client(params)
    end)
  end

  defp refill_params(params_chunk) do
    TrustScoreScheduler.push_params_chunk(params_chunk)

    if job_not_scheduled?() do
      %{} |> __MODULE__.new(schedule_in: @delay) |> Oban.insert()
    end
  end

  defp job_not_scheduled? do
    from(j in Oban.Job,
      where: j.queue == "default" and (j.state == "scheduled" or j.state == "available"),
      select: count(j.id)
    )
    |> Repo.one()
    |> Kernel.==(0)
  end

  @doc """
  Clears all scheduled jobs for the default queue.
  Function used in TrustScoreScheduler when starting application
  """
  def clear_scheduled_jobs, do: Repo.delete_all(from(j in Oban.Job, where: j.queue == "default"))
end
