defmodule ShopifyDemo.Repo do
  use Ecto.Repo,
    otp_app: :shopify_demo,
    adapter: Ecto.Adapters.Postgres
end
