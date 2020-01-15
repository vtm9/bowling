defmodule Bowling.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @states ~w(active finished)

  schema "games" do
    has_many(:players, Bowling.Player)
    has_many(:frames, Bowling.Frame)

    field :state, :string, default: "active"
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:state])
    |> cast_assoc(:players, required: true)
    |> validate_inclusion(:state, @states)
  end
end
