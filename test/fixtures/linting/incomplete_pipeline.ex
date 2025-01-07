defmodule IncompletePipeline do
  def foo(bars) do
    bars |> hd() |> String.downcase() |> String.to_existing_atom()
  end
end
