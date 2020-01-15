defmodule BowlingWeb.Api.ThrowControllerTest do
  use BowlingWeb.ConnCase

  describe "POST" do
    test "creates throw", %{conn: conn} do
      game = insert(:game)

      conn =
        conn
        |> post(Routes.game_throw_path(conn, :create, game.id), %{throw: %{score: 5}})

      json_response(conn, 201)

      assert Bowling.Repo.count(Bowling.Frame) == 1
      assert Bowling.Repo.count(Bowling.Throw) == 1
    end

    test "validates", %{conn: conn} do
      game = insert(:game)

      conn =
        conn
        |> post(Routes.game_throw_path(conn, :create, game.id), %{throw: %{score: 37}})

      assert json_response(conn, 422)

      assert Bowling.Repo.count(Bowling.Frame) == 0
      assert Bowling.Repo.count(Bowling.Throw) == 0
    end

    test "creates throw for each players", %{conn: conn} do
      game = insert(:game)

      post(conn, Routes.game_throw_path(conn, :create, game.id), %{throw: %{score: 5}})
      post(conn, Routes.game_throw_path(conn, :create, game.id), %{throw: %{score: 4}})
      post(conn, Routes.game_throw_path(conn, :create, game.id), %{throw: %{score: 3}})
      post(conn, Routes.game_throw_path(conn, :create, game.id), %{throw: %{score: 1}})

      assert Bowling.Repo.count(Bowling.Frame) == 2
      assert Bowling.Repo.count(Bowling.Throw) == 4
    end
  end
end
