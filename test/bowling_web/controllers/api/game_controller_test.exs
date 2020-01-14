defmodule BowlingWeb.Api.GameControllerTest do
  use BowlingWeb.ConnCase

  describe "POST" do
    test "create game", %{conn: conn} do
      conn =
        conn
        |> post("/api/v1/games")

      assert json_response(conn, 201)
      assert get_req_header(conn, "location")
    end
  end

  describe "GET" do
    test "show game", %{conn: conn} do
      conn =
        conn
        |> get("/api/v1/games/1")

      assert json_response(conn, 200)
    end
  end
end
