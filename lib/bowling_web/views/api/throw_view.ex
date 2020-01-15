defmodule BowlingWeb.Api.ThrowView do
  use BowlingWeb, :view
  alias __MODULE__

  def render("index.json", %{throws: throws}) do
    %{data: render_many(throws, ThrowView, "throw.json")}
  end

  def render("throw.json", %{throw: throw}) do
    %{id: throw.id}
  end
end
