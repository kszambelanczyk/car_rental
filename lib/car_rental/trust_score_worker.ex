defmodule CarRental.TrustScoreScheduler do
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

  # schedule work every week
  @delay 60 * 60 * 24 * 7 * 1000

  defp schedule_work do
    Process.send_after(self(), :work, @delay)
  end
end
