use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :remit, RemitWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :remit, Remit.Repo,
  username: "postgres",
  password: "postgres",
  database: "remit_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

import_config "dev.local.exs"
