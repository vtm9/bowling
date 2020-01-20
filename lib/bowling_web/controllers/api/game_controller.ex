defmodule BowlingWeb.Api.GameController do
  use BowlingWeb, :controller

  alias Bowling.Game

  action_fallback BowlingWeb.Api.FallbackController

  def create(conn, %{"game" => game_params}) do
    with {:ok, %Game{} = game} <- Bowling.create_game(game_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.game_path(conn, :show, game))
      |> render("create.json", game: game)
    end
  end

  def show(conn, %{"id" => id}) do
    {game, result} = Bowling.get_game_result(id)

    conn
    |> render("show.json", game: game, result: result)
  end
end
