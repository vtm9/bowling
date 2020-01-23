import Config

secret_key_base = System.get_env("SECRET_KEY_BASE")
database_url = System.get_env("DATABASE_URL")

config :bowling, BowlingWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  secret_key_base: secret_key_base,
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]

config :bowling, Bowling.Repo,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE", "2"))
