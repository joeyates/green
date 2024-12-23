defmodule NeedlessPipeline do
  def foo(input) do
    input |> String.strip()

    input |> String.strip() |> String.downcase()
  end
end
