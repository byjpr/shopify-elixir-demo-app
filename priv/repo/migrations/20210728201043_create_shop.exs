defmodule ShopifyDemo.Repo.Migrations.CreateShop do
  use Ecto.Migration

  def change do
    create table("shops") do
      add :shopify_id, :string
      add :name, :string
      add :currency, :string
      add :money_format, :string
      add :myshopify_domain, :string
      add :shopify_plan, :string
      add :email, :string

      # access tokens
      add :access_token, :string
      add :token_version, :string

      timestamps()
    end
  end
end
