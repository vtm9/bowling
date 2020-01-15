defmodule Bowling.Throw do
  use Ecto.Schema
  import Ecto.Changeset

  schema "throws" do
    belongs_to(:frame, Bowling.Frame)

    field(:score, :integer)
    timestamps(updated_at: false)
  end

  @doc false
  def changeset(throw, attrs) do
    throw
    |> cast(attrs, [:score])
    |> cast_assoc(:frame)
    |> validate_required([:score])
    |> validate_number(:score, greater_than_or_equal_to: 0, less_than_or_equal_to: 10)
  end

  def build(throw_params) do
    %__MODULE__{}
    |> changeset(throw_params)
    |> apply_action(:insert)
  end
end
