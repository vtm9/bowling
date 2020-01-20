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

  def create_throw(game_id, throw_params) do
    game = get_full_game!(game_id)

    case game.state do
      "active" ->
        active_frame = get_active_frame(game)

        case Bowling.Throw.build(throw_params) do
          {:ok, throw} ->
            Bowling.Throw.build(throw_params)
            throws = [throw | active_frame.throws]

            active_frame
            |> Bowling.Frame.changeset(%{throws: throws})
            |> maybe_finish_frame(throws)
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
      throws: []
    })
  end

  defp get_active_player(game) do
    active_player_index = rem(Enum.count(game.frames), Enum.count(game.players))
    Enum.at(game.players, active_player_index)
  end

  defp maybe_finish_frame(changeset, throws) do
    if need_to_finish_frame(throws) do
      Ecto.Changeset.change(changeset, %{state: "finished"})
    else
      changeset
    end
  end

  defp need_to_finish_frame(throws) do
    cond do
      Enum.count(throws) >= 2 -> true
      get_total_throws_score(throws) >= 10 -> true
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
    game_throws = frames |> Enum.map(& &1.throws) |> List.flatten()

    frames
    |> Enum.with_index()
    |> Enum.reduce({0, []}, fn {frame, frame_index}, {total, acc_frames} ->
      frame_result = get_frame_result(frame, frame_index, game_throws)
      new_total = total + frame_result

      new_frames =
        Enum.concat(acc_frames, [
          %{
            result: frame_result,
            throws: Enum.map(frame.throws, &Map.take(&1, [:score]))
          }
        ])

      {new_total, new_frames}
    end)
  end

  defp get_frame_result(frame, _frame_index, game_throws) do
    case get_frame_type(frame) do
      :strike -> get_strike_result(frame, game_throws)
      :spare -> get_spare_result(frame, game_throws)
      :common -> get_total_throws_score(frame)
    end
  end

  defp get_frame_type(frame) do
    case frame.throws do
      [%{score: 10} | _] -> :strike
      [%{score: x}, %{score: y}] when x + y == 10 -> :spare
      _ -> :common
    end
  end

  defp get_strike_result(frame, game_throws) do
    [first_throw | _] = frame.throws
    throw_index = game_throws |> Enum.find_index(fn throw -> throw.id == first_throw.id end)
    game_throws |> Enum.slice(throw_index..(throw_index + 2)) |> get_total_throws_score
  end

  defp get_spare_result(frame, game_throws) do
    [_ | [second_throw | _]] = frame.throws
    throw_index = game_throws |> Enum.find_index(fn throw -> throw.id == second_throw.id end)
    game_throws |> Enum.at(throw_index + 1) |> Map.get(:score, 0) |> Kernel.+(10)
  end

  defp get_total_throws_score(%Bowling.Frame{} = frame) do
    frame |> Map.get(:throws, []) |> get_total_throws_score
  end

  defp get_total_throws_score(throws) do
    throws |> Enum.map(&Map.get(&1, :score, 0)) |> Enum.sum()
  end
end
