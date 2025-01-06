defmodule NestedSecondParameter do
  def foo(first, second) do
    first |> String.downcase() |> Path.join(String.downcase(second))
  end
end
