# This file is responsible for configuring our application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :glup,
  ecto_repos: [Glup.Repo]

# Configures the endpoint
config :glup, GlupWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GlupWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Glup.PubSub,
  live_view: [signing_salt: "HZrpMhCT"]

# Configurate the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :glup, Glup.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :joken, default_signer: "secret"

# Configure Mailgun
config :glup, Glup.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: "cc17b3204bd8500785209698e450239d-02fa25a3-4bca7c7d",
  domain: "https://api.mailgun.net/v3/sandboxd2567aed406b4a318140946af8d484db.mailgun.org"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
