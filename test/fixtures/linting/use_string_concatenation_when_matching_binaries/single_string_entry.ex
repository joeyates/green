defmodule BitstringWithSingleStringEntry do
  def to_atom("ciao"), do: :ciao

  def is_ciao!(text) do
    "ciao" = text
  end
end
