defmodule FavorPipeline do
  def foo(input) do
    input
    |> String.strip()
    |> String.downcase()
    |> IO.inspect(label: String.capitalize("big label"))
  end
end
