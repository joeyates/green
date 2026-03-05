defmodule Green.Rules.Linting.AvoidNeedlessPipelines do
  @moduledoc """
  This rule transforms single-function pipelines into function calls.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      avoid_needless_pipelines: [
        enabled: *true | false,
        except: [
          "path/to/file.exs",
          {"path/to/other_file.exs", 42},
          {"path/to/yet_another_file.exs", [10, 20, 30]}
        ]
      ]
    ]
  ```
  """

  @behaviour Green.Rule
  @rule_name :avoid_needless_pipelines

  alias Green.Options

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    rule_opts = get_in(opts, [:green, @rule_name]) || []

    if rule_opts[:enabled] do
      do_apply({forms, comments}, rule_opts)
    else
      {forms, comments}
    end
  end

  defp do_apply({forms, comments}, rule_opts) do
    except_lines = rule_opts[:except_lines] || []

    {forms, _acc} =
      Macro.prewalk(forms, %{in_pipeline: false}, fn
        # Skip nodes that are already in a pipeline
        {:|>, _context, [{:|>, _, _} | _rest]} = node, acc ->
          {node, %{acc | in_pipeline: true}}

        # Transform
        {:|>, context, right} = node, %{in_pipeline: false} = acc ->
          [first, {function, _ctx, rest}] = right

          modified =
            if rest do
              {function, context, [first | rest]}
            else
              {function, context, [first]}
            end

          if context[:line] in except_lines do
            {node, acc}
          else
            {modified, acc}
          end

        other, acc ->
          {other, acc}
      end)

    {forms, comments}
  end

  defp prepare_opts(opts) do
    opts
    |> Options.set_value(
      [@rule_name],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end
end
