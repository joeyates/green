defmodule LastEntryNotBytes do
  def foo(text) do
    length = byte_size(text)
    <<_first::bytes-1, rest::bytes-size(length - 1)>> = text
    rest
  end
end
