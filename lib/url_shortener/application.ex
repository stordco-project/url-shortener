defmodule UrlShortener.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    UrlShortener.Config.load!()

    children = [
      UrlShortener.Repo,
      UrlShortenerWeb.Telemetry,
      {Phoenix.PubSub, name: UrlShortener.PubSub},
      UrlShortenerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: UrlShortener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    UrlShortenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
