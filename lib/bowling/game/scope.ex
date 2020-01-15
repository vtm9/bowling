defmodule Bowling.Scope do
  @moduledoc false

  import Ecto.Query

  def full_game(query) do
    from game in query,
      left_join: players in assoc(game, :players),
      left_join: frames in assoc(game, :frames),
      left_join: throws in assoc(frames, :throws),
      order_by: [asc: throws.id],
      preload: [
        players: players,
        frames: {frames, throws: throws}
      ]
  end
end
