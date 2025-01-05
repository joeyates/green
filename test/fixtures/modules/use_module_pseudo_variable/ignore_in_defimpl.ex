defmodule Foo do
  defimpl Inspect do
    def inspect(foo, _) do
      Foo.bar()
    end
  end
end
