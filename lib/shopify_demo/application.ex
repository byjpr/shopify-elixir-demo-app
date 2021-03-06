defmodule ShopifyDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ShopifyDemo.Repo,
      # Start the Telemetry supervisor
      ShopifyDemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ShopifyDemo.PubSub},
      # Start the Endpoint (http/https)
      ShopifyDemoWeb.Endpoint,
      # Start a worker by calling: ShopifyDemo.Worker.start_link(arg)
      # {ShopifyDemo.Worker, arg}
      {Oban, oban_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShopifyDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ShopifyDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:shopify_demo, Oban)
  end
end
