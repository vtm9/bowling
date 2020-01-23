defmodule Bowling do
  alias Bowling.Game
  alias Bowling.GameResult
  alias Bowling.Repo
  alias Bowling.Scope

  @max_frames_count 10

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

    case get_game_state(game) do
      "active" ->
        current_frame = get_current_frame(game)

        case Bowling.Ball.build(ball_params) do
          {:ok, ball} ->
            balls = Enum.concat(current_frame.balls, [ball])

            current_frame
            |> Bowling.Frame.changeset(%{balls: balls})
            |> maybe_finish_frame(game, balls)
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

  def get_frame_type(balls) do
    case balls do
      [%{score: 10} | _] -> :strike
      [%{score: x}, %{score: y} | _] when x + y == 10 -> :spare
      _ -> :open
    end
  end

  defp get_current_frame(game) do
    current_frame =
      game
      |> Map.get(:frames, [])
      |> Enum.find(fn frame -> frame_active?(frame) end)

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

  defp maybe_finish_frame(frame_changeset, game, balls) do
    if need_to_finish_frame(frame_changeset, game, balls) do
      Ecto.Changeset.change(frame_changeset, %{state: "finished"})
    else
      frame_changeset
    end
  end

  defp need_to_finish_frame(frame_changeset, game, balls) do
    frames_count = get_frames_count(game, frame_changeset)
    frame_type = get_frame_type(balls)
    balls_count = Enum.count(balls)

    case {frames_count, frame_type} do
      {@max_frames_count, :strike} ->
        balls_count == 3

      {@max_frames_count, :spare} ->
        balls_count == 3

      {_, :strike} ->
        true

      {_, :spare} ->
        true

      _ ->
        balls_count == 2
    end
  end

  defp get_frames_count(game, frame_changeset) do
    current_frame_num = if Ecto.get_meta(frame_changeset.data, :state) == :built, do: 1, else: 0

    prev_frame_count =
      game
      |> Map.get(:frames, [])
      |> Enum.filter(fn frame -> frame.player_id == frame_changeset.data.player_id end)
      |> Enum.count()

    prev_frame_count + current_frame_num
  end

  def frame_active?(frame), do: frame.state == "active"

  def get_game_state(game) do
    finished_frames_count =
      game
      |> Map.get(:frames, [])
      |> Enum.filter(fn frame -> !frame_active?(frame) end)
      |> Enum.count()

    if finished_frames_count < Enum.count(game.players) * @max_frames_count do
      "active"
    else
      "finished"
    end
  end
end
