defmodule CarRental.Clients do
  @moduledoc """
  Mock clients DB
  """
  alias CarRental.Clients.Client
  alias CarRental.Clients.Params

  @clients_count 100

  @spec list_clients() :: {:ok, [Client.t()]}
  def list_clients do
    clients = for _ <- 1..@clients_count, do: generate_client()

    {:ok, clients}
  end

  @spec save_score_for_client(Params.t()) :: {:ok, atom()}
  def save_score_for_client(%Params{}) do
    {:ok, :saved}
  end

  defp generate_client do
    %Client{
      id: 4 |> :crypto.strong_rand_bytes() |> :binary.decode_unsigned(),
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      phone: Faker.Phone.EnUs.phone(),
      age: Enum.random(20..70),
      license_number: Faker.Code.isbn10(),
      license_expiry: (365 * 5) |> Faker.Date.forward() |> Date.to_string(),
      residential_address: Faker.Address.street_address(),
      credit_card_info: Faker.Code.isbn13(),
      rental_history: generate_rental_history()
    }
  end

  defp generate_rental_history do
    for _ <- 1..Enum.random(1..5) do
      %{
        car_id: 4 |> :crypto.strong_rand_bytes() |> :binary.decode_unsigned(),
        rental_date: 365 |> Faker.Date.backward() |> Date.to_string(),
        return_date: 365 |> Faker.Date.forward() |> Date.to_string()
      }
    end
  end
end
