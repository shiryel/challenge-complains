# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :complains_server,
  namespace: CS


# Configures the endpoint
config :complains_server, CSWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XYXRBDjsPCQQWHpfwuVX3xUUlXnR66R+GsbuKZ/J032OHLYY6z9PJ+1SCILkxHzP",
  render_errors: [view: CSWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: CS.PubSub,
  live_view: [signing_salt: "kkal5yeZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
