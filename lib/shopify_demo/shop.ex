defmodule ShopifyDemo.Shop do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shops" do
    field :shopify_id, :string
    field :name, :string
    field :currency, :string
    field :money_format, :string
    field :myshopify_domain, :string
    field :shopify_plan, :string
    field :email, :string

    # access tokens
    field :access_token, :string

    timestamps()
  end

  #
  # Changesets
  #
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(
      params,
      ~w(shopify_id name email currency money_format myshopify_domain shopify_plan access_token)a
    )
    # |> cast_embed(:settings)
    |> unique_constraint(:myshopify_domain)
  end
end
