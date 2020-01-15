defmodule Bowling.Repo.Migrations.CreateThrows do
  use Ecto.Migration

  def change do
    create table(:throws) do
      add :game_id, references(:games)
      add :frame_id, references(:frames)
      add :score, :integer

      add :inserted_at, :utc_datetime, null: false
    end
  end
end
