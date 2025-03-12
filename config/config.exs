import Config

config :car_rental,
  ecto_repos: [CarRental.Repo],
  generators: [timestamp_type: :utc_datetime]

config :car_rental, Oban,
  engine: Oban.Engines.Lite,
  queues: [default: 10],
  repo: CarRental.Repo,
  plugins: [Oban.Plugins.Pruner]

import_config "#{config_env()}.exs"
