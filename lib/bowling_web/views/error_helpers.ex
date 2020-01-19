defmodule BowlingWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(BowlingWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(BowlingWeb.Gettext, "errors", msg, opts)
    end
  end
end
