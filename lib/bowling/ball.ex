defmodule Bowling.Ball do
  use Ecto.Schema
  import Ecto.Changeset

  schema "balls" do
    belongs_to(:frame, Bowling.Frame)

    field(:score, :integer)
    timestamps(updated_at: false)
  end

  @doc false
  def changeset(ball, attrs) do
    ball
    |> cast(attrs, [:score])
    |> cast_assoc(:frame)
    |> validate_required([:score])
    |> validate_number(:score, greater_than_or_equal_to: 0, less_than_or_equal_to: 10)
  end

  def build(ball_params) do
    %__MODULE__{}
    |> changeset(ball_params)
    |> apply_action(:insert)
  end
end
