Mimic.copy(CarRental.Clients)
Mimic.copy(CarRental.TrustScore)
Mimic.copy(CarRental.TrustScoreScheduler)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(CarRental.Repo, :manual)
