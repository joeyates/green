defmodule MixedEntries do
  def foo(text) do
    <<?a, _bar::bytes-size(2)>> <> "ciao" <> <<_baz>> <> rest = text
    rest
  end
end
