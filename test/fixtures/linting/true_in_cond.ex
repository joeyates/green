defmodule TrueInCond do
  def classify(param) do
    cond do
      is_list(param) ->
        :list

      true ->
        :other
    end
  end
end
