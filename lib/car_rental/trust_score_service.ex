defmodule CarRental.TrustScoreService do
  @moduledoc """
  Business logic for fetching clients and preparing params for trust score calculation.
  """

  alias CarRental.Clients
  alias CarRental.TrustScore.Params.ClientParams

  @doc """
  Fetch clients and prepare params for trust score calculation.
  Assuming with Clients.list_clients/0 we get all clients from the db.
  """
  @spec prepare_client_params() :: {:ok, list(list(ClientParams.t()))}
  def prepare_client_params do
    {:ok, clients} = Clients.list_clients()
    {:ok, prepare_params(clients)}
  end

  @batch_size 100

  defp prepare_params(clients) do
    clients
    |> Enum.map(fn client ->
      %ClientParams{
        client_id: client.id,
        age: client.age,
        license_number: client.license_number,
        rentals_count: length(client.rental_history)
      }
    end)
    |> Enum.chunk_every(@batch_size)
  end
end
