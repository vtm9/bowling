defmodule BowlingWeb.Api.GameControllerTest do
  use BowlingWeb.ConnCase

  describe "POST" do
    test "creates game", %{conn: conn} do
      conn =
        conn
        |> post("/api/v1/games", %{game: %{players: [%{name: "p1"}, %{name: "p2"}]}})

      response = json_response(conn, 201)

      assert Map.take(response, ["players"]) == %{
               "players" => [%{"name" => "p1"}, %{"name" => "p2"}]
             }

      assert get_req_header(conn, "location")

      assert Bowling.Repo.count(Bowling.Game) == 1
      assert Bowling.Repo.count(Bowling.Player) == 2
    end

    test "validates", %{conn: conn} do
      conn =
        conn
        |> post("/api/v1/games", %{game: %{}})

      response = json_response(conn, 422)

      assert response == %{"errors" => %{"players" => ["can't be blank"]}}
      assert Bowling.Repo.count(Bowling.Game) == 0
    end
  end

  describe "GET" do
    test "shows game", %{conn: conn} do
      game = insert(:game)

      conn =
        conn
        |> get(Routes.game_path(conn, :show, game.id))

      assert json_response(conn, 200)
    end
  end
end
