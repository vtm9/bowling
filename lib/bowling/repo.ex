defmodule Bowling.Repo do
  use Ecto.Repo,
    otp_app: :bowling,
    adapter: Ecto.Adapters.Postgres

  def count(q), do: Bowling.Repo.aggregate(q, :count, :id)
end
