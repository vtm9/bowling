defmodule BowlingWeb.Router do
  use BowlingWeb, :router
  use Plug.ErrorHandler

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", BowlingWeb.Api do
    pipe_through :api

    resources "/games", GameController, only: [:create, :show] do
      resources "/balls", BallController, only: [:create]
    end
  end

  def handle_errors(conn, %{reason: %Ecto.NoResultsError{}}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "NOT_FOUND"})
    |> halt
  end

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{}}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "NOT_FOUND"})
    |> halt
  end
end
