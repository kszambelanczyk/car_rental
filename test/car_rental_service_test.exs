defmodule CarRentalServiceTest do
  use ExUnit.Case

  alias CarRental.TrustScore.Params.ClientParams
  alias CarRental.TrustScoreService

  describe "prepare_client_params/0" do
    test "it returns chunked list of client params" do
      assert {:ok, [params | _]} = TrustScoreService.prepare_client_params()
      assert length(params) == 100
      assert [%ClientParams{} | _] = params
    end
  end
end
