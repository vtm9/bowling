defmodule BowlingWeb.Api.ThrowController do
  use BowlingWeb, :controller

  action_fallback BowlingWeb.Api.FallbackController

  def create(conn, %{"game_id" => game_id, "throw" => throw_params}) do
    with {:ok, _} <- Bowling.create_throw(game_id, throw_params) do
      conn
      |> put_status(:created)
      |> json(%{})
    end
  end
end
