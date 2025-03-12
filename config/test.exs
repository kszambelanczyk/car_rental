import Config

config :car_rental, CarRental.Repo,
  database: Path.expand("../car_rental_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

config :car_rental, Oban, testing: :manual
