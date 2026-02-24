defmodule Green.Rules.Linting.AvoidNeedlessPipelines do
  @moduledoc """
  This rule transforms single-function pipelines into function calls.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      avoid_needless_pipelines: [
        enabled: *true | false
      ]
    ]
  ```
  """

  @behaviour Green.Rule

  alias Green.Options

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:avoid_needless_pipelines][:enabled]
    do_apply({forms, comments}, enabled)
  end

  defp do_apply({forms, comments}, falsey) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy) do
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

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:avoid_needless_pipelines],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end
end
