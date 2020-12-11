defmodule UrlShortenerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :url_shortener

  if Application.get_env(:url_shortener, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_url_shortener_key",
    signing_salt: "85jnUNak"
  ]

  socket "/socket", UrlShortenerWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :url_shortener,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :url_shortener
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug UrlShortenerWeb.Router

  def init(_type, config) do
    config = Keyword.merge(config, runtime_config())

    {:ok, config}
  end

  defp runtime_config do
    %{url: url, port: port} = UrlShortener.Config.fetch!(:endpoint)

    %URI{scheme: url_scheme, host: url_host, port: url_port} = URI.parse(url)

    [
      url: [scheme: url_scheme, host: url_host, port: url_port],
      http: [:inet6, port: port]
    ]
  end
end
