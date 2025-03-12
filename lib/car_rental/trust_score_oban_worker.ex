defmodule CarRental.TrustScoreObanWorker do
  use Oban.Worker, max_attempts: 1

  import Ecto.Query

  alias CarRental.Repo
  alias CarRental.TrustScoreService

  require Logger

  @delay 3

  @impl true
  def perform(%{args: _args}) do
    Logger.info("Performing trust score worker")

    with :ok <- TrustScoreService.calculate_trust_score() do
      %{}
      |> new(schedule_in: @delay)
      |> Oban.insert()
    end
    |> dbg
  end

  def perform(%{args: _args}) do
    # update_timezone(id)

    :ok
  end

  # defp fetch_next(current_id) do
  #   User
  #   |> where([u], is_nil(u.timezone))
  #   |> where([u], u.id > ^current_id)
  #   |> order_by(asc: :id)
  #   |> limit(1)
  #   |> select([u], u.id)
  #   |> Repo.one()
  # end

  # defp update_timezone(_id), do: Enum.random([:ok, {:error, :reason}])
end
