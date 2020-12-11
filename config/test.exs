use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :url_shortener, UrlShortener.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :url_shortener, UrlShortenerWeb.Endpoint,
  http: [port: 4002],
  server: true

config :url_shortener, :sql_sandbox, true

config :wallaby,
  chromedriver: [
    headless: true
    # headless: false
  ],
  otp_app: :url_shortener,
  js_errors: true,
  js_logger: false,
  screenshot_on_failure: true

# Print only warnings and errors during test
config :logger, level: :warn
