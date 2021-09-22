defmodule ShopifyDemo.Oauth do
  @moduledoc """
  OAuth2 strategy for Shopify
  """
  use OAuth2.Strategy
  require Logger

  @client_id ShopifyDemo.ConfLoader.fetch(:shopify_conf)[:client_id]
  @client_secret ShopifyDemo.ConfLoader.fetch(:shopify_conf)[:client_secret]
  @redirect_uri ShopifyDemo.ConfLoader.fetch(:shopify_conf)[:redirect_uri]
  @params ShopifyDemo.ConfLoader.fetch(:shopify_conf)[:base_params]

  # Public API
  def client(shop) do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: @client_id,
      client_secret: @client_secret,
      redirect_uri: @redirect_uri,
      site: "https://#{shop}.myshopify.com",
      authorize_url: "/admin/oauth/authorize",
      token_url: "/admin/oauth/access_token"
    )
  end

  def client(shop, token) do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: @client_id,
      client_secret: @client_secret,
      redirect_uri: @redirect_uri,
      site: "https://#{shop}.myshopify.com",
      authorize_url: "/admin/oauth/authorize",
      token_url: "/admin/oauth/access_token",
      other_params: %{"scope" => @params},
      token: %OAuth2.AccessToken{
        access_token: token,
        token_type: "Bearer"
      }
    )
  end

  def authorize_url!(shopid, params \\ @params), do: OAuth2.Client.authorize_url!(client(shopid), params)

  def get_token!(shopid, params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(shopid), params, headers, opts)
  end

  # Strategy Callbacks
  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
