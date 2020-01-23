defmodule BowlingWeb.Api.GameView do
  use BowlingWeb, :view

  def render("show.json", %{game: game, result: result}) do
    %{id: game.id, result: result}
  end
end
