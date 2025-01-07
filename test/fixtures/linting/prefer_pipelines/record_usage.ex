defmodule RecordUsage do
  require Record

  Record.defrecordp(:foo, [:bar, :baz])

  def qux(record) do
    String.upcase(foo(record, :bar))
  end
end
