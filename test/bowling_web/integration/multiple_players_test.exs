defmodule BowlingWeb.Integration.MultiplePlayersTest do
  use BowlingWeb.ConnCase

  test "custom game", %{conn: conn} do
    conn = post(conn, "/api/v1/games", %{game: %{players: [%{name: "p1"}, %{name: "p2"}]}})

    game_id = json_response(conn, 201)["id"]

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 1}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 2}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 3}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 1}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 9}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 2}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 8}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 5}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 6}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 3}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 3}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 5}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 6}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 6}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 10}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 10}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 1}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 2}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 1}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 2}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 3}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 5}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 1}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 2}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 1}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 2}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 3}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 4}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 6}})
    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 6}})

    post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 10}})

    get_conn = get(conn, Routes.game_path(conn, :show, game_id))

    assert json_response(get_conn, 200) == %{
             "id" => game_id,
             "result" => [
               %{
                 "frames" => [
                   %{"balls" => [%{"score" => 1}, %{"score" => 2}], "result" => 3},
                   %{"balls" => [%{"score" => 1}, %{"score" => 9}], "result" => 14},
                   %{"balls" => [%{"score" => 4}, %{"score" => 5}], "result" => 9},
                   %{"balls" => [%{"score" => 3}, %{"score" => 4}], "result" => 7},
                   %{"balls" => [%{"score" => 6}, %{"score" => 4}], "result" => 20},
                   %{"balls" => [%{"score" => 10}], "result" => 13},
                   %{"balls" => [%{"score" => 1}, %{"score" => 2}], "result" => 3},
                   %{"balls" => [%{"score" => 3}, %{"score" => 4}], "result" => 7},
                   %{"balls" => [%{"score" => 1}, %{"score" => 2}], "result" => 3},
                   %{"balls" => [%{"score" => 3}, %{"score" => 4}], "result" => 7}
                 ],
                 "player_name" => "p1",
                 "total" => 86
               },
               %{
                 "frames" => [
                   %{"balls" => [%{"score" => 3}, %{"score" => 4}], "result" => 7},
                   %{"balls" => [%{"score" => 2}, %{"score" => 8}], "result" => 16},
                   %{"balls" => [%{"score" => 6}, %{"score" => 3}], "result" => 9},
                   %{"balls" => [%{"score" => 4}, %{"score" => 5}], "result" => 9},
                   %{"balls" => [%{"score" => 6}, %{"score" => 4}], "result" => 20},
                   %{"balls" => [%{"score" => 10}], "result" => 13},
                   %{"balls" => [%{"score" => 1}, %{"score" => 2}], "result" => 3},
                   %{"balls" => [%{"score" => 4}, %{"score" => 5}], "result" => 9},
                   %{"balls" => [%{"score" => 1}, %{"score" => 2}], "result" => 3},
                   %{
                     "balls" => [%{"score" => 4}, %{"score" => 6}, %{"score" => 6}],
                     "result" => 16
                   }
                 ],
                 "player_name" => "p2",
                 "total" => 105
               }
             ]
           }
  end
end
