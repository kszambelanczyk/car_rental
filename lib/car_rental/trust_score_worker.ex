defmodule CarRental.TrustScoreWorker do
  use GenServer

  require Logger

  # Client API

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  # Server callbacks

  @impl true
  def init(state) do
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    # Do the desired work here
    # ...

    # Reschedule once more
    schedule_work()

    {:noreply, state}
  end

  # @one_week_in_milliseconds 7 * 24 * 60 * 60 * 1000
  @one_week_in_milliseconds 1000

  defp schedule_work do
    # Logger.info("Scheduling work in #{@one_week_in_milliseconds} milliseconds")
    Process.send_after(self(), :work, @one_week_in_milliseconds)
  end
end
