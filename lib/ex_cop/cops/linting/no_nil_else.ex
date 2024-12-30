defmodule ExCop.Cops.Linting.NoNilElse do
  @moduledoc """
  This module removes `else` clauses that return `nil`.
  """

  @behaviour ExCop.Cop

  @impl true
  def apply({forms, comments}, _opts) do
    forms =
      Macro.prewalk(forms, fn
        {:if, context,
         [
           condition,
           [
             {{:__block__, ctx1, [:do]}, do_expression},
             {{:__block__, _ctx2, [:else]}, {:__block__, _ctx, [nil]}}
           ]
         ]} ->
          {:if, context,
           [
             condition,
             [
               {{:__block__, ctx1, [:do]}, do_expression}
             ]
           ]}

        other ->
          other
      end)

    {forms, comments}
  end
end
