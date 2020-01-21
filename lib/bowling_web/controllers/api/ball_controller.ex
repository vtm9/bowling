defmodule BowlingWeb.Api.BallController do
  use BowlingWeb, :controller

  action_fallback BowlingWeb.Api.FallbackController

  def create(conn, %{"game_id" => game_id, "ball" => ball_params}) do
    with {:ok, _} <- Bowling.create_ball(game_id, ball_params) do
      conn
      |> put_status(:created)
      |> json(%{})
    end
  end
end
