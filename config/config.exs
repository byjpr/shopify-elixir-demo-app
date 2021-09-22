# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :shopify_demo,
  ecto_repos: [ShopifyDemo.Repo]

# Configures the endpoint
config :shopify_demo, ShopifyDemoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S5U9zqqhP8/UTH7TF9u1NGs0pn+7a42tBXBd0PcgDphKRd/8i/4cCMb5zEVKrxZp",
  render_errors: [view: ShopifyDemoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ShopifyDemo.PubSub,
  live_view: [signing_salt: "chx5BQur"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
