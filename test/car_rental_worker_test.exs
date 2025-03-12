defmodule CarRental.TrustScoreWorkerTest do
  use ExUnit.Case, async: false
  use Mimic

  alias CarRental.TrustScore

  setup :set_mimic_global

  describe "TrustScoreWorker" do
    test "performs score calculation on work message handler" do
      {:ok, pid} = GenServer.start_link(CarRental.TrustScoreWorker, [])
      send(pid, :work)

      self = self()
      expect(TrustScore, :calculate_score, fn _ ->
        send(self, :ok)
      end)

      assert_receive :ok
    end
  end
end
