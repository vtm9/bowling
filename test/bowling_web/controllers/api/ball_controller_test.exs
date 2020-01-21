defmodule BowlingWeb.Api.BallControllerTest do
  use BowlingWeb.ConnCase

  describe "POST" do
    test "creates ball", %{conn: conn} do
      game = insert(:game)

      conn =
        conn
        |> post(Routes.game_ball_path(conn, :create, game.id), %{ball: %{score: 5}})

      json_response(conn, 201)

      assert Bowling.Repo.count(Bowling.Frame) == 1
      assert Bowling.Repo.count(Bowling.Ball) == 1
    end

    test "validates", %{conn: conn} do
      game = insert(:game)

      conn =
        conn
        |> post(Routes.game_ball_path(conn, :create, game.id), %{ball: %{score: 37}})

      assert json_response(conn, 422)

      assert Bowling.Repo.count(Bowling.Frame) == 0
      assert Bowling.Repo.count(Bowling.Ball) == 0
    end

    test "creates ball for each players", %{conn: conn} do
      game = insert(:game)

      post(conn, Routes.game_ball_path(conn, :create, game.id), %{ball: %{score: 5}})
      post(conn, Routes.game_ball_path(conn, :create, game.id), %{ball: %{score: 4}})
      post(conn, Routes.game_ball_path(conn, :create, game.id), %{ball: %{score: 3}})
      post(conn, Routes.game_ball_path(conn, :create, game.id), %{ball: %{score: 1}})

      assert Bowling.Repo.count(Bowling.Frame) == 2
      assert Bowling.Repo.count(Bowling.Ball) == 4
    end
  end
end
