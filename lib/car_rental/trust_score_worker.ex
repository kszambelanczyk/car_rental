defmodule CarRental.TrustScoreWorker do
  @moduledoc false
  use GenServer

  alias CarRental.TrustScoreService

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(state) do
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    TrustScoreService.calculate_trust_scores()

    schedule_work()

    {:noreply, state}
  end

  # delay above 10 requests per minute
  @delay 7 * 1000

  defp schedule_work do
    Logger.info("Scheduling work in #{@delay} milliseconds")
    Process.send_after(self(), :work, @delay)
  end
end
