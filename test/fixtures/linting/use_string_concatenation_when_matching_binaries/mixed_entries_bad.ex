defmodule MixedEntries do
  def foo(text) do
    <<?a, _bar::bytes-size(2), "ciao", _baz, rest::bytes>> = text
    rest
  end
end
