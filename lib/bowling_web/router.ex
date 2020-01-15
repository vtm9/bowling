defmodule BowlingWeb.Router do
  use BowlingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", BowlingWeb.Api do
    pipe_through :api

    resources "/games", GameController, only: [:create, :show] do
      resources "/throws", ThrowController, only: [:create]
    end
  end
end
