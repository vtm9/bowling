defmodule Bowling.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :state, :string

      timestamps()
    end
  end
end
