defmodule Bowling.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Bowling.Repo

  def game_factory do
    %Bowling.Game{players: build_list(1, :player)}
  end

  def player_factory do
    %Bowling.Player{name: sequence(:player_name, &"name-#{&1}")}
  end
end
