defmodule NoElseWithUnless do
  def foo(value) do
    if value do
      "It's true"
    else
      "It's false"
    end
  end
end
