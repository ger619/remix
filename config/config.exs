# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :remit,
  ecto_repos: [Remit.Repo]

# Configures the endpoint
config :remit, RemitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z3jNpGSi9O3xwZDuqvcDd2pIItkwbcnEWreuHVe3+LPiyvENeb8GOPg9D1v8XSpI",
  render_errors: [view: RemitWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Remit.PubSub, adapter: Phoenix.PubSub.PG2]

config :remit, Remit.SMS, adapter: Remit.SMSLogAdapater

config :scrivener_html,
  routes_helper: RemitWeb.Router.Helpers

# Configures Phauxth authentication
config :phauxth,
  user_context: Remit.Accounts,
  crypto_module: Bcrypt,
  token_module: RemitWeb.Auth.Token

# If you're using Guardian in yobSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
