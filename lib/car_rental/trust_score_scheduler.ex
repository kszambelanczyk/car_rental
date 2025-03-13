defmodule CarRental.TrustScoreScheduler do
  @moduledoc false
  use GenServer

  alias CarRental.TrustScoreService
  alias CarRental.TrustScoreWorker

  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def pop_params_chunk do
    GenServer.call(__MODULE__, :pop_params_chunk)
  end

  def push_params_chunk(params) do
    GenServer.cast(__MODULE__, {:push_params_chunk, params})
  end

  @impl true
  def init(_state) do
    send(self(), :work)

    TrustScoreWorker.clear_scheduled_jobs()

    {:ok, %{batched_params: []}}
  end

  @impl true
  def handle_call(:pop_params_chunk, _from, %{batched_params: [params | rest]} = state) do
    {:reply, params, %{state | batched_params: rest}}
  end

  @impl true
  def handle_call(:pop_params_chunk, _from, %{batched_params: []} = state) do
    {:reply, nil, state}
  end

  @impl true
  def handle_cast({:push_params_chunk, params}, state) do
    {:noreply, %{state | batched_params: [params | state.batched_params]}}
  end

  @impl true
  def handle_info(:work, _state) do
    schedule_work()

    {:ok, batched_params} = TrustScoreService.prepare_client_params()

    {:noreply, %{batched_params: batched_params}, {:continue, :start_oban_worker}}
  end

  @impl true
  def handle_continue(:start_oban_worker, state) do
    %{} |> TrustScoreWorker.new() |> Oban.insert()

    {:noreply, state}
  end

  # schedule work every week
  @delay 60 * 60 * 24 * 7 * 1000

  defp schedule_work, do: Process.send_after(self(), :work, @delay)
end
