defmodule NilElse do
  def foo(param) do
    if param do
      :ok
    end
  end
end
