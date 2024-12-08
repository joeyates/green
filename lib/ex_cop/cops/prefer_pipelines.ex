defmodule ExCop.Cops.PreferPipelines do
  @moduledoc """
  This cop transforms nested function calls into pipelines.
  """

  def apply({forms, comments}) do
    forms =
      Macro.prewalk(forms, fn
        # Transform function applications that have a function application as first argument
        {{:., _, _}, _context, [{{:., _, _}, _, _} | _rest]} = node ->
          to_pipeline(node)

        other ->
          other
      end)

    {forms, comments}
  end

  defp to_pipeline({{:., _, _} = left, context, [first | rest]}) do
    # TODO: Create proper contexts
    {:|>, context, [to_pipeline(first), {left, context, rest}]}
  end

  defp to_pipeline(node), do: node
end
