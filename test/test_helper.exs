Mimic.copy(CarRental.TrustScore)
Mimic.copy(CarRental.Clients)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(CarRental.Repo, :manual)
