defmodule FavorPipeline do
  def foo(input) do
    IO.inspect(String.downcase(String.strip(input)), label: String.capitalize("big label"))
  end
end
