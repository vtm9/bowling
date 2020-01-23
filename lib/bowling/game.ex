defmodule Bowling.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    has_many(:players, Bowling.Player)
    has_many(:frames, Bowling.Frame)

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [])
    |> cast_assoc(:players, required: true)
  end
end
