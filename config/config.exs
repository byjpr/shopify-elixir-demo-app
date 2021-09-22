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

# Configure your shopify app
config :shopify_demo, :shopify_conf,
  client_id: "INSERT_DEV_CLIENT_ID", # This comes from your Shopify Partner App page
  client_secret: "INSERT_DEV_CLIENT_SECRET", # This comes from your Shopify Partner App page
  redirect_uri: "https://example.com/return", # This should be the same as the one you created in the Partner page
  base_params: "read_products, write_products" # The minimum needed

# Oban jobs conf
config :shopify_demo, Oban,
  repo: ShopifyDemo.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
