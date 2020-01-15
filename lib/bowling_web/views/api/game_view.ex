defmodule BowlingWeb.Api.GameView do
  use BowlingWeb, :view

  def render("show.json", %{game: game}) do
    %{id: game.id, players: render_players(game)}
  end

  defp render_players(game) do
    game
    |> Map.get(:players, [])
    |> Enum.map(&Map.take(&1, [:name]))
  end
end
