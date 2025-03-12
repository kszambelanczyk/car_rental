import Config

config :car_rental, CarRental.Repo,
  database: Path.expand("../car_rental_dev.db", __DIR__),
  pool_size: 5,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true
