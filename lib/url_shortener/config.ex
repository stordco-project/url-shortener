defmodule UrlShortener.Config do
  use Vapor.Planner

  @key __MODULE__

  dotenv()

  config :endpoint, env([
    {:port, "ENDPOINT_PORT", map: &String.to_integer/1},
    {:url, "ENDPOINT_URL"}
  ])

  def load! do
    config = Vapor.load!(@key)

    :persistent_term.put(@key, config)

    config
  end

  def fetch!(group) do
    config = :persistent_term.get(@key)

    Map.fetch!(config, group)
  end

  def fetch!(group, var) do
    group
    |> fetch!()
    |> Map.fetch!(var)
  end
end
