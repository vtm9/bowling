defmodule Bowling do
  alias Bowling.Game
  alias Bowling.GameResult
  alias Bowling.Repo
  alias Bowling.Scope

  def get_full_game!(id) do
    Game
    |> Scope.full_game()
    |> Repo.get!(id)
  end

  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  def create_ball(game_id, ball_params) do
    game = get_full_game!(game_id)

    case game.state do
      "open" ->
        open_frame = get_open_frame(game)

        case Bowling.Ball.build(ball_params) do
          {:ok, ball} ->
            Bowling.Ball.build(ball_params)
            balls = [ball | open_frame.balls]

            open_frame
            |> Bowling.Frame.changeset(%{balls: balls})
            |> maybe_finish_frame(balls)
            |> Repo.insert_or_update()

          {:error, changeset} ->
            {:error, changeset}
        end

      "finished" ->
        {:error, :game_finished}
    end
  end

  def get_game_result(%Game{} = game) do
    GameResult.call(game)
  end

  def get_game_result(id) do
    id
    |> get_full_game!()
    |> get_game_result()
  end

  defp get_open_frame(game) do
    open_frame =
      game
      |> Map.get(:frames, [])
      |> Enum.find(fn frame -> Bowling.Frame.is_open?(frame) end)

    case open_frame do
      nil -> build_new_frame(game)
      frame -> frame
    end
  end

  defp build_new_frame(game) do
    Ecto.build_assoc(game, :frames, %{
      player_id: get_active_player(game).id,
      game_id: game.id,
      balls: []
    })
  end

  defp get_active_player(game) do
    active_player_index = rem(Enum.count(game.frames), Enum.count(game.players))
    Enum.at(game.players, active_player_index)
  end

  defp maybe_finish_frame(changeset, balls) do
    if need_to_finish_frame(balls) do
      Ecto.Changeset.change(changeset, %{state: "finished"})
    else
      changeset
    end
  end

  defp need_to_finish_frame(balls) do
    cond do
      Enum.count(balls) >= 2 -> true
      GameResult.get_total_balls_score(balls) >= 10 -> true
      true -> false
    end
  end
end
