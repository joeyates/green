defmodule TrueInCond do
  def classify(param) do
    cond do
      is_list(param) ->
        :list

      :other ->
        :other
    end
  end
end
