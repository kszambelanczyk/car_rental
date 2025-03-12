defmodule CarRental.TrustScoreWorkerStarter do
  @moduledoc """
  Starts the trust score worker.
  """

  import Ecto.Query

  alias CarRental.TrustScoreWorker
  alias CarRental.Repo

  def start_worker() do
    if not worker_scheduled?() do
      %{}
      |> TrustScoreWorker.new()
      |> Oban.insert()
    end
  end

  def worker_scheduled? do
    count =
      Oban.Job
      |> where(state: "scheduled")
      |> select(count())
      |> Repo.one()

    count > 0
  end
end
