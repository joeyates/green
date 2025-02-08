defmodule Green.Rules.Linting.AvoidNeedlessPipelines do
  @moduledoc """
  This cop transforms single-function pipelines into function calls.
  """

  @behaviour Green.Rule

  @impl true
  def apply({forms, comments}, _opts) do
    {forms, _acc} =
      Macro.prewalk(forms, %{in_pipeline: false}, fn
        # Skip nodes that are already in a pipeline
        {:|>, _context, [{:|>, _, _} | _rest]} = node, acc ->
          {node, %{acc | in_pipeline: true}}

        # Transform
        {:|>, context, right}, %{in_pipeline: false} = acc ->
          [first, {function, _ctx, rest}] = right

          if rest do
            {{function, context, [first | rest]}, acc}
          else
            {{function, context, [first]}, acc}
          end

        other, acc ->
          {other, acc}
      end)

    {forms, comments}
  end
end
