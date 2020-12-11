Application.put_env(:wallaby, :base_url, UrlShortenerWeb.Endpoint.url())
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(UrlShortener.Repo, :manual)
