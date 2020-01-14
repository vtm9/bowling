defmodule BowlingWeb.Api.GameController do
  use BowlingWeb, :controller

  def create(conn, %{}) do
    id = 1

    conn
    |> put_resp_header("location", BowlingWeb.Router.Helpers.game_path(conn, :show, id))
    |> put_status(:created)
    |> json(%{})
  end

  def show(conn, %{"id" => id}) do
    conn
    |> json(%{id: id})
  end
end
