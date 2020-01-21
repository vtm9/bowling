defmodule Bowling do
  alias Bowling.Game
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
      "active" ->
        active_frame = get_active_frame(game)

        case Bowling.Ball.build(ball_params) do
          {:ok, ball} ->
            Bowling.Ball.build(ball_params)
            balls = [ball | active_frame.balls]

            active_frame
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

  def get_game_result(id) do
    id
    |> get_full_game!()
    |> calc_game_result()
  end

  defp get_active_frame(game) do
    current_frame =
      game
      |> Map.get(:frames, [])
      |> Enum.find(fn frame -> frame.state == "active" end)

    case current_frame do
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
      get_total_balls_score(balls) >= 10 -> true
      true -> false
    end
  end

  defp calc_game_result(game) do
    result =
      game
      |> Map.get(:players, [])
      |> Enum.map(fn player ->
        {total, frames} =
          game
          |> Map.get(:frames, [])
          |> Enum.filter(fn frame -> frame.player_id == player.id end)
          |> calc_frames_result

        %{player_name: player.name, total: total, frames: frames}
      end)

    {game, result}
  end

  defp calc_frames_result(frames) do
    game_balls = frames |> Enum.map(& &1.balls) |> List.flatten()

    frames
    |> Enum.with_index()
    |> Enum.reduce({0, []}, fn {frame, frame_index}, {total, acc_frames} ->
      frame_result = get_frame_result(frame, frame_index, game_balls)
      new_total = total + frame_result

      new_frames =
        Enum.concat(acc_frames, [
          %{
            result: frame_result,
            balls: Enum.map(frame.balls, &Map.take(&1, [:score]))
          }
        ])

      {new_total, new_frames}
    end)
  end

  defp get_frame_result(frame, _frame_index, game_balls) do
    case get_frame_type(frame) do
      :strike -> get_strike_result(frame, game_balls)
      :spare -> get_spare_result(frame, game_balls)
      :common -> get_total_balls_score(frame)
    end
  end

  defp get_frame_type(frame) do
    case frame.balls do
      [%{score: 10} | _] -> :strike
      [%{score: x}, %{score: y}] when x + y == 10 -> :spare
      _ -> :common
    end
  end

  defp get_strike_result(frame, game_balls) do
    [first_ball | _] = frame.balls
    ball_index = game_balls |> Enum.find_index(fn ball -> ball.id == first_ball.id end)
    game_balls |> Enum.slice(ball_index..(ball_index + 2)) |> get_total_balls_score
  end

  defp get_spare_result(frame, game_balls) do
    [_ | [second_ball | _]] = frame.balls
    ball_index = game_balls |> Enum.find_index(fn ball -> ball.id == second_ball.id end)
    game_balls |> Enum.at(ball_index + 1) |> Map.get(:score, 0) |> Kernel.+(10)
  end

  defp get_total_balls_score(%Bowling.Frame{} = frame) do
    frame |> Map.get(:balls, []) |> get_total_balls_score
  end

  defp get_total_balls_score(balls) do
    balls |> Enum.map(&Map.get(&1, :score, 0)) |> Enum.sum()
  end
end
