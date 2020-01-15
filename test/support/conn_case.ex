defmodule BowlingWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      alias BowlingWeb.Router.Helpers, as: Routes
      import Bowling.Factory

      @endpoint BowlingWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Bowling.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Bowling.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
