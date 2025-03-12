defmodule CarRentalServiceTest do
  use ExUnit.Case
  use Mimic

  alias CarRental.Clients
  alias CarRental.TrustScore
  alias CarRental.TrustScoreService

  defp score_helper(%{clients: clients}) do
    Enum.map(clients, fn client ->
      %Response{id: client.client_id, score: :rand.uniform(100)}
    end)
  end

  describe "calculate_trust_scores/0" do
    test "it calculates and saves scores for fetched clients" do
      expect(TrustScore, :calculate_score, &score_helper/1)
      expect(Clients, :save_score_for_client, 100, fn _ -> {:ok, :saved} end)

      assert TrustScoreService.calculate_trust_scores() == :ok
    end

    test "it returns error for too many clients" do
      expect(Clients, :list_clients, fn -> {:error, :too_many_clients} end)

      assert {:error, _} = TrustScoreService.calculate_trust_scores()
    end

    test "it returns error when rate limit is exceeded" do
      expect(TrustScore, :calculate_score, fn _ -> {:error, "Rate limit exceeded"} end)

      assert {:error, _} = TrustScoreService.calculate_trust_scores()
    end
  end
end
