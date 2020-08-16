use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :complains_server, CSWeb.Endpoint,
  http: [port: 4002],
  server: false

config :complains_server, :db,
  name: :mongo,
  database: "test",
  pool_size: 20,
  seeds: [
    "0.0.0.0:27017"
  ]

# Print only warnings and errors during test
config :logger, level: :warn
