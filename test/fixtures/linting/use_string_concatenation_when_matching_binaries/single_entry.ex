defmodule BinaryWithASingleEntry do
  def foo(text) do
    <<all::bytes>> = text
    all
  end
end
