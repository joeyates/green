defmodule Module.Calls do
  def foo(bar) do
    bar |> __MODULE__.Baz.qux() |> String.downcase()
  end
end
