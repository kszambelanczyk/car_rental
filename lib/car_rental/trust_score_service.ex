defmodule CarRental.TrustScoreService do
  @moduledoc """
  Business logic for updating client trust scores.
  It handles fetching clients, building params, calculating scores, and saving results.
  """

  alias CarRental.Clients
  alias CarRental.TrustScore

  @doc """
  Calculate trust scores for clients and updates them with the results.
  In real application I assume that function returning clients from the db
  would fetch only the clients that have no score or have the score expired.
  Expiration time would be 1 week, according to the task requirements.
  """
  @spec calculate_trust_scores() :: :ok | {:error, String.t()}
  def calculate_trust_scores do
    with {:ok, clients} <- Clients.list_clients(),
         params = prepare_params(clients),
         scores when is_list(scores) <- TrustScore.calculate_score(params) do
      save_scores(scores)
      :ok
    end
  end

  defp prepare_params(clients) do
    client_params =
      clients
      # limit the number of clients to 100 just to be consistent with the task description
      # in real life we would limit the number of clients in the clients context in list_clients/0 function
      |> Enum.take(100)
      |> Enum.map(fn client ->
        %{
          client_id: client.id,
          age: client.age,
          license_number: client.license_number,
          rentals_count: length(client.rental_history)
        }
      end)

    %TrustScore.Params{clients: client_params}
  end

  # In real application this function would also set a date of score calculation
  # so we can use it to fetch only clients that don't have a score yet or have the score expired.
  defp save_scores(scores) do
    Enum.each(scores, fn score ->
      params = %Clients.Params{client_id: score.id, score: score.score}
      # in real this function could also return error
      {:ok, _} = Clients.save_score_for_client(params)
    end)
  end
end
