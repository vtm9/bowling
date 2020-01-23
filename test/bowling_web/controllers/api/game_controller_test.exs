defmodule BowlingWeb.Api.GameControllerTest do
  use BowlingWeb.ConnCase

  describe "POST" do
    test "creates game", %{conn: conn} do
      conn =
        conn
        |> post("/api/v1/games", %{game: %{players: [%{name: "p1"}, %{name: "p2"}]}})

      response = json_response(conn, 201)

      assert Map.take(response, ["result"]) == %{
               "result" => [
                 %{"frames" => [], "player_name" => "p1", "total" => 0},
                 %{"frames" => [], "player_name" => "p2", "total" => 0}
               ]
             }

      assert get_req_header(conn, "location")

      assert Bowling.Repo.count(Bowling.Game) == 1
      assert Bowling.Repo.count(Bowling.Player) == 2
    end

    test "validates players", %{conn: conn} do
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
      game = insert(:game, %{players: [%{name: "p1"}, %{name: "p2"}]})
      [player1, player2] = game.players

      insert(:frame, %{game: game, player: player1, balls: [%{score: 10}]})
      insert(:frame, %{game: game, player: player1, balls: [%{score: 7}, %{score: 3}]})
      insert(:frame, %{game: game, player: player1, balls: [%{score: 9}, %{score: 0}]})

      insert(:frame, %{game: game, player: player2, balls: [%{score: 3}, %{score: 4}]})
      insert(:frame, %{game: game, player: player2, balls: [%{score: 10}]})

      conn =
        conn
        |> get(Routes.game_path(conn, :show, game.id))

      assert json_response(conn, 200) == %{
               "id" => game.id,
               "result" => [
                 %{
                   "frames" => [
                     %{"result" => 20, "balls" => [%{"score" => 10}]},
                     %{
                       "result" => 19,
                       "balls" => [%{"score" => 7}, %{"score" => 3}]
                     },
                     %{
                       "result" => 9,
                       "balls" => [%{"score" => 9}, %{"score" => 0}]
                     }
                   ],
                   "player_name" => "p1",
                   "total" => 48
                 },
                 %{
                   "frames" => [
                     %{
                       "result" => 7,
                       "balls" => [%{"score" => 3}, %{"score" => 4}]
                     },
                     %{"result" => 10, "balls" => [%{"score" => 10}]}
                   ],
                   "player_name" => "p2",
                   "total" => 17
                 }
               ]
             }
    end

    test "renders not found", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, Routes.game_path(conn, :show, -1))
      end
    end
  end
end
