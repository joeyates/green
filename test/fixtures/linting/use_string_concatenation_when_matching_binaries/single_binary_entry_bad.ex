defmodule BitstringWithSingleBinaryEntry do
  def foo(text) do
    <<all::binary>> = text
    all
  end
end
