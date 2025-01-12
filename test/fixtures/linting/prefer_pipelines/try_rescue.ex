defmodule TryRescue do
  def foo(items) do
    try do
      Enum.map(items, &String.downcase/1)
    rescue
      e in ArgumentError ->
        []
    end
    |> :erlang.list_to_binary()
  end
end
