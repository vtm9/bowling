defmodule Bowling.Frame do
  use Ecto.Schema
  import Ecto.Changeset

  @states ~w(active finished)

  schema "frames" do
    belongs_to(:game, Bowling.Game)
    belongs_to(:player, Bowling.Player)
    has_many(:throws, Bowling.Throw)

    field :state, :string, default: "active"
    timestamps()
  end

  @doc false
  def changeset(game, attrs \\ %{}) do
    game
    |> cast(attrs, [:player_id, :game_id, :state])
    |> put_assoc(:throws, attrs.throws)
    |> validate_inclusion(:state, @states)
  end
end
