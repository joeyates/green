defmodule NestedSecondParameter do
  def foo(first, second) do
    Path.join(String.downcase(first), String.downcase(second))
  end
end
