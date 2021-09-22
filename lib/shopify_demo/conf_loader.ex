defmodule ShopifyDemo.ConfLoader do
  @moduledoc """
  Provider to resolve runtime environmental variables
  """

  @spec fetch(atom) :: any | String.t
  def fetch(key) do
    case Application.get_env(:shopify_demo, key) do
      nil -> "CONF_NOT_SET"
      value -> value
    end
  end
end
