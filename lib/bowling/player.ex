defmodule Bowling.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    belongs_to(:game, Bowling.Game)
    has_many(:frames, Bowling.Frame)
    field(:name, :string)
    timestamps()
  end

  @doc false
  def changeset(ball, attrs) do
    ball
    |> cast(attrs, [:name])
    |> validate_required([])
  end
end
