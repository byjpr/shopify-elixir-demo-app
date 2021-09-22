defmodule ShopifyDemoWeb.OauthController do
  use ShopifyDemoWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
    and the user has inputted a Shop name which is the third level domain of myshopify.com.
    (EG: the `jordansawesomestore` part of `jordansawesomestore.myshopify.com`)
    Sends the user to `shop.`myshopify.com to authorise the application
  """
  def authorise(conn, %{shop: shop}) do
    conn
    |> redirect(external: OAuth.authorize_url!(shop))
  end

  def authorise(conn, _) do
    conn
    |> put_status(400)
    |> put_resp_header("location", ShopifyDemoWeb.Routes.auth_path(conn, :index))
    |> put_view(ShopifyDemoWeb.ErrorView)
    |> render("400.html")
    |> halt()
  end

  @doc """
    Endpoint Shopify redirects too after OAuth flow
    params: `code` is access token
  """

  def callback(conn, %{code: code, shop: myshopify}) do
    subdomain =
      myshopify
      |> replace(:myshopify)
      |> replace(:https)
      |> replace(:http)

    token =
      OAuth.get_token!(
        subdomain,
        code: code,
        client_id: OAuth.client().client_id,
        client_secret: OAuth.client().client_secret
      )

    create_shop_record(token: token, subdomain: subdomain, myshopify: myshopify)

    render(conn, "installing.html")
  end

  def callback(conn, _) do
    conn
    |> put_status(400)
    |> put_resp_header("location", ShopifyDemoWeb.Routes.auth_path(conn, :index))
    |> put_view(ShopifyDemoWeb.ErrorView)
    |> render("400.html")
    |> halt()
  end

  # =======================================
  #
  # Private functions
  #
  # =======================================

  defp replace(string, :myshopify), do: String.replace(string, ".myshopify.com", "")
  defp replace(string, :https), do: String.replace(string, "https://", "")
  defp replace(string, :http), do: String.replace(string, "http://", "")

  defp create_shop_record(
         token: %{token: %{access_token: token}},
         subdomain: subdomain,
         myshopify: myshopify
       ) do
    decoded_token = token |> Jason.decode!()

    %{
      "plan" => %{
        "displayName" => plan,
        "partnerDevelopment" => _is_dev,
        "shopifyPlus" => _is_plus
      },
      "currencyCode" => currency,
      "email" => email,
      "id" => id
    } = get_basic_info(decoded_token["access_token"], subdomain)

    changeset =
      ShopifyDemo.Shop.changeset(%{}, %{
        shopify_id: id,
        name: subdomain,
        myshopify_domain: myshopify,
        access_token: decoded_token["access_token"],
        shopify_plan: plan,
        currency: currency,
        email: email
      })

      ShopifyDemo.Repo.insert(changeset)
  end

  defp get_basic_info(token, shop) do
    graphql = """
    {
      shop {
        id
        name
        currencyCode
        email
        plan {
          displayName
          partnerDevelopment
          shopifyPlus
        }
      }
    }
    """

    {:ok,
     %Shopify.GraphQL.Response{
       body: %{
         "data" => %{
           "shop" => response
         }
       }
     }} =
      Shopify.GraphQL.send(
        graphql,
        access_token: token,
        retry: Shopify.GraphQL.Retry.Linear,
        retry_opts: [retry_in: 250],
        shop: shop
      )

    response
  end
end
