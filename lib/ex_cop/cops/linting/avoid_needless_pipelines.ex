defmodule ExCop.Cops.Linting.AvoidNeedlessPipelines do
  @moduledoc """
  This cop transforms single-function pipelines into function calls.
  """

  def apply({forms, comments}, _opts) do
    {forms, _acc} =
      Macro.prewalk(forms, %{in_pipeline: false}, fn
        # Skip nodes that are already in a pipeline
        {:|>, _context, [{:|>, _, _} | _rest]} = node, acc ->
          {node, %{acc | in_pipeline: true}}

        # Transform
        {:|>, context, right}, %{in_pipeline: false} = acc ->
          [first, {{:., _, _} = function, _ctx, rest}] = right

          {{function, context, [first | rest]}, acc}

        other, acc ->
          {other, acc}
      end)

    {forms, comments}
  end
end
