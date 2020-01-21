defmodule Bowling.Repo.Migrations.CreateBalls do
  use Ecto.Migration

  def change do
    create table(:balls) do
      add :game_id, references(:games)
      add :frame_id, references(:frames)
      add :score, :integer

      add :inserted_at, :utc_datetime, null: false
    end
  end
end
