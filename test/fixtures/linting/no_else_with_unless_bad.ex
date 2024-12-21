defmodule NoElseWithUnless do
  def foo(value) do
    unless value do
      "It's false"
    else
      "It's true"
    end
  end
end
