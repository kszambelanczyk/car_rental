defmodule CarRental.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CarRental.Repo,
      {CarRental.TrustScore.RateLimiter, []},
      {Oban, Application.fetch_env!(:car_rental, Oban)},
      ] ++ workers()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CarRental.Supervisor]
    Supervisor.start_link(children, opts)
  end

  if Mix.env() == :test do
    defp workers, do: []
  else
    defp workers, do: [{CarRental.TrustScoreScheduler, []}]
  end
end
