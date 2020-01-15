current_time = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

game = Bowling.Repo.insert!(%Bowling.Game{})

player1 = Bowling.Repo.insert!(%Bowling.Player{name: "p1", game_id: game.id})
player2 = Bowling.Repo.insert!(%Bowling.Player{name: "p2", game_id: game.id})

frames =
  Enum.map(1..20, fn _i ->
    Enum.map([player1, player2], fn player ->
      %{
        player_id: player.id,
        state: "finished",
        game_id: game.id,
        updated_at: current_time,
        inserted_at: current_time
      }
    end)
  end)
  |> List.flatten()

Bowling.Repo.insert_all(Bowling.Frame, frames)

throws =
  Bowling.Frame
  |> Bowling.Repo.all()
  |> Enum.map(fn frame ->
    [
      %{
        frame_id: frame.id,
        score: :rand.uniform(5),
        inserted_at: current_time
      }
    ]
    |> List.duplicate(:rand.uniform(1) + 1)
  end)
  |> List.flatten()

Bowling.Repo.insert_all(Bowling.Throw, throws)
