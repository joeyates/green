defmodule Module.Calls do
  def foo(bar) do
    String.downcase(__MODULE__.Baz.qux(bar))
  end
end
