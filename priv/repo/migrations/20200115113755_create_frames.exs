defmodule Bowling.Repo.Migrations.CreateFrames do
  use Ecto.Migration

  def change do
    create table(:frames) do
      add :game_id, references(:games)
      add :player_id, references(:players)
      add :state, :string

      timestamps()
    end
  end
end
