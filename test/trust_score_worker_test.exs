defmodule TrustScoreWorkerTest do
  use CarRental.Case
  use Mimic

  alias CarRental.TrustScore
  alias CarRental.TrustScore.Params.ClientParams
  alias CarRental.TrustScoreScheduler
  alias CarRental.TrustScoreWorker

  test "when performed it schedules next job run" do
    params_chunk = [
      %ClientParams{
        client_id: 1,
        age: 20,
        license_number: "1234567890",
        rentals_count: 1
      }
    ]

    expect(TrustScoreScheduler, :pop_params_chunk, fn -> params_chunk end)

    expect(TrustScore, :calculate_score, fn params ->
      assert %{clients: ^params_chunk} = params
      []
    end)

    assert :ok == perform_job(TrustScoreWorker, %{})
  end

  test "on calculation error it pushes back the params to the scheduler" do
    params_chunk = [
      %ClientParams{
        client_id: 1,
        age: 20,
        license_number: "1234567890",
        rentals_count: 1
      }
    ]

    expect(TrustScoreScheduler, :pop_params_chunk, fn -> params_chunk end)
    expect(TrustScore, :calculate_score, fn _ -> {:error, "error"} end)

    expect(TrustScoreScheduler, :push_params_chunk, fn params ->
      assert params_chunk == params
    end)

    assert {:error, _} = perform_job(TrustScoreWorker, %{})
  end
end
