defmodule IncompletePipeline do
  def foo(bars) do
    hd(bars) |> String.downcase() |> String.to_existing_atom()
  end
end
