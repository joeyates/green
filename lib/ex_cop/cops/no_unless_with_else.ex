defmodule ExCop.Cops.NoUnlessWithElse do
  @moduledoc """
  This cop transforms `unless` with `else` into `if` with `else`.
  """

  def apply({forms, comments}) do
    forms =
      Macro.prewalk(forms, fn
        {:unless, context,
         [
           condition,
           [
             {{:__block__, ctx1, [:do]}, do_expression},
             {{:__block__, ctx2, [:else]}, else_expression}
           ]
         ]} ->
          {:if, context,
           [
             condition,
             [
               {{:__block__, ctx1, [:do]}, else_expression},
               {{:__block__, ctx2, [:else]}, do_expression}
             ]
           ]}

        other ->
          other
      end)

    {forms, comments}
  end
end
