defmodule ShopifyDemoWeb.PageController do
  use ShopifyDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
