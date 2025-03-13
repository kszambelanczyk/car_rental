defmodule CarRental.TrustScoreSchedulerTest do
  use CarRental.Case, async: false
  use Mimic

  alias CarRental.Clients
  alias CarRental.TrustScore.Params.ClientParams
  alias CarRental.TrustScoreScheduler
  alias CarRental.TrustScoreWorker

  setup :set_mimic_global

  describe "TrustScoreScheduler" do
    test "when started it schedules oban worker" do
      start_supervised!(TrustScoreScheduler)
      assert_enqueued([worker: TrustScoreWorker], 100)
    end

    test "it pops next chunk of params" do
      start_supervised!(TrustScoreScheduler)
      assert params = TrustScoreScheduler.pop_params_chunk()
      assert [%ClientParams{} | _] = params
    end

    test "it pushes params chunk" do
      expect(Clients, :list_clients, fn -> {:ok, []} end)

      start_supervised!(TrustScoreScheduler)

      param_chunk = [
        %ClientParams{
          client_id: 1,
          age: 20,
          license_number: "1234567890",
          rentals_count: 1
        }
      ]

      assert :ok == TrustScoreScheduler.push_params_chunk(param_chunk)

      assert param_chunk == TrustScoreScheduler.pop_params_chunk()
    end
  end
end
