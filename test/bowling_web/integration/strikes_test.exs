defmodule BowlingWeb.Integration.StrikesTest do
  use BowlingWeb.ConnCase

  test "all strikes, total 300", %{conn: conn} do
    conn = post(conn, "/api/v1/games", %{game: %{players: [%{name: "p1"}]}})

    game_id = json_response(conn, 201)["id"]

    Enum.each(1..15, fn _ ->
      post(conn, Routes.game_ball_path(conn, :create, game_id), %{ball: %{score: 10}})
    end)

    get_conn = get(conn, Routes.game_path(conn, :show, game_id))

    assert json_response(get_conn, 200) == %{
             "id" => game_id,
             "result" => [
               %{
                 "frames" => [
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{"balls" => [%{"score" => 10}], "result" => 30},
                   %{
                     "balls" => [%{"score" => 10}, %{"score" => 10}, %{"score" => 10}],
                     "result" => 30
                   }
                 ],
                 "player_name" => "p1",
                 "total" => 300
               }
             ]
           }
  end
end
