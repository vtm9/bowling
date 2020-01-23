defmodule BowlingWeb.Api.GameController do
  use BowlingWeb, :controller

  alias Bowling.Game

  action_fallback BowlingWeb.Api.FallbackController

  def create(conn, %{"game" => game_params}) do
    with {:ok, %Game{} = game} <- Bowling.create_game(game_params) do
      {game, result} = Bowling.get_game_result(game.id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.game_path(conn, :show, game))
      |> render("show.json", game: game, result: result)
    end
  end

  def show(conn, %{"id" => id}) do
    {game, result} = Bowling.get_game_result(id)

    conn
    |> put_status(:ok)
    |> render("show.json", game: game, result: result)
  end
end
