defmodule Bowling.GameResult do
  def call(game) do
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

  def get_total_balls_score(%Bowling.Frame{} = frame) do
    frame |> Map.get(:balls, []) |> get_total_balls_score
  end

  def get_total_balls_score(balls) do
    balls |> Enum.map(&Map.get(&1, :score, 0)) |> Enum.sum()
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
end
