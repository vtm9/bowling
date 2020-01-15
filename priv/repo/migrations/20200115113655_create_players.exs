defmodule Bowling.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :game_id, references(:games)
      add :name, :string

      timestamps()
    end
  end
end
