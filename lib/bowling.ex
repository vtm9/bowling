defmodule Bowling do
  alias Bowling.Game
  alias Bowling.Repo
  alias Bowling.Scope

  def list_games do
    Repo.all(Game)
  end

  def get_game!(id), do: Repo.get!(Game, id)

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
      get_frame_score(throws) >= 10 -> true
      true -> false
    end
  end

  defp get_frame_score(throws) do
    Enum.reduce(throws, 0, fn throw, acc -> acc + throw.score end)
  end
end
