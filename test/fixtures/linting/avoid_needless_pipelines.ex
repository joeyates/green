defmodule NeedlessPipeline do
  def foo(input) do
    String.strip(input)

    input |> String.strip() |> String.downcase()
  end
end
