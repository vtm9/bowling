defmodule BowlingWeb.Api.GameView do
  use BowlingWeb, :view

  def render("create.json", %{game: game}) do
    %{
      id: game.id,
      result:
        Enum.map(game.players, fn player -> %{frames: [], player_name: player.name, total: 0} end)
    }
  end

  def render("show.json", %{game: game, result: result}) do
    %{id: game.id, result: result}
  end
end
