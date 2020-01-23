defmodule BowlingWeb.Integration.SparesTest do
  use BowlingWeb.ConnCase

  test "all spares, total 150", %{conn: conn} do
    conn = post(conn, "/api/v1/games", %{game: %{players: [%{name: "p1"}]}})

    game_id = json_response(conn, 201)["id"]

    Enum.each(1..25, fn _ ->
      post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 5}})
    end)

    get_conn = get(conn, Routes.game_path(conn, :show, game_id))

    assert json_response(get_conn, 200) == %{
             "id" => game_id,
             "result" => [
               %{
                 "frames" => [
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{"balls" => [%{"score" => 5}, %{"score" => 5}], "result" => 15},
                   %{
                     "balls" => [%{"score" => 5}, %{"score" => 5}, %{"score" => 5}],
                     "result" => 15
                   }
                 ],
                 "player_name" => "p1",
                 "total" => 150
               }
             ]
           }
  end
end
