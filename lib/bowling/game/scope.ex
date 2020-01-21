defmodule Bowling.Scope do
  @moduledoc false

  import Ecto.Query

  def full_game(query) do
    from game in query,
      left_join: players in assoc(game, :players),
      left_join: frames in assoc(game, :frames),
      left_join: balls in assoc(frames, :balls),
      order_by: [asc: balls.id],
      preload: [
        players: players,
        frames: {frames, balls: balls}
      ]
  end
end
