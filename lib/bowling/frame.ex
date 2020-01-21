defmodule Bowling.Frame do
  use Ecto.Schema
  import Ecto.Changeset

  @states ~w(open finished)

  schema "frames" do
    belongs_to(:game, Bowling.Game)
    belongs_to(:player, Bowling.Player)
    has_many(:balls, Bowling.Ball)

    field :state, :string, default: "open"
    timestamps()
  end

  @doc false
  def changeset(frame, attrs \\ %{}) do
    frame
    |> cast(attrs, [:player_id, :game_id, :state])
    |> put_assoc(:balls, attrs.balls)
    |> validate_inclusion(:state, @states)
  end

  def is_open?(frame), do: frame.state == "open"
end
