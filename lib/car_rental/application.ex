defmodule CarRental.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        {CarRental.TrustScore.RateLimiter, []}
      ] ++ workers()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CarRental.Supervisor]
    Supervisor.start_link(children, opts)
  end

  if Mix.env() == :test do
    defp workers, do: []
  else
    defp workers, do: [{CarRental.TrustScoreWorker, []}]
  end
end
