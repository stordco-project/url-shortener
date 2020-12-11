defmodule UrlShortener.Repo do
  use Ecto.Repo,
    otp_app: :url_shortener,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    runtime_config =
      Vapor.load!(__MODULE__.Config).repo
      |> Enum.into([])

    {:ok, Keyword.merge(config, runtime_config)}
  end

  defmodule Config do
    use Vapor.Planner

    dotenv()

    config :repo,
           env([
             {:hostname, "PG_HOST"},
             {:username, "PG_USERNAME"},
             {:password, "PG_PASSWORD"},
             {:database, "PG_DATABASE"},
             {:show_sensitive_data_on_connection_error, "PG_SENSITIVE_DATA",
              map: &String.to_existing_atom/1},
             {:pool_size, "PG_POOL_SIZE", map: &String.to_integer/1}
           ])
  end
end
