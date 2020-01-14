defmodule Bowling.Repo do
  use Ecto.Repo,
    otp_app: :bowling,
    adapter: Ecto.Adapters.Postgres
end
