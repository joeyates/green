defmodule NilElse do
  def foo(param) do
    if param do
      :ok
    else
      nil
    end
  end
end
