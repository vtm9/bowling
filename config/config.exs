# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bowling,
  ecto_repos: [Bowling.Repo]

# Configures the endpoint
config :bowling, BowlingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wZNgEk4MlzPI9EtAq1m7XAV+K4dJeH5+y1JJE1D4EyPdI4SgGV4COeGX+yS8/pGc",
  render_errors: [view: BowlingWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Bowling.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
