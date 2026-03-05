defmodule Green.Rules.Parentheses.UseParenthesesWithZeroArityFunctions do
  @moduledoc """
  This module adds parentheses to zero-arity function and macro definitions.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      use_parentheses_with_zero_arity_functions: [
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
  @rule_name :use_parentheses_with_zero_arity_functions

  alias Green.Options

  @definition_keywords [:def, :defp, :defmacro, :defmacrop]

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:use_parentheses_with_zero_arity_functions][:enabled]
    do_apply({forms, comments}, enabled, opts)
  end

  defp do_apply({forms, comments}, falsey, _opts) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy, opts) do
    except_lines = opts[:green][:use_parentheses_with_zero_arity_functions][:except_lines] || []

    forms =
      Macro.prewalk(forms, fn
        # The `nil`, and the lack of a `:closing` value means no parameters
        {keyword, context, [{name, head_context, nil} | rest] = right}
        when keyword in @definition_keywords ->
          right =
            cond do
              head_context[:closing] ->
                right

              head_context[:line] in except_lines ->
                right

              true ->
                line = Keyword.fetch!(head_context, :line)
                head_context = Keyword.put(head_context, :closing, line: line)
                [{name, head_context, []} | rest]
            end

          {keyword, context, right}

        other ->
          other
      end)

    {forms, comments}
  end

  defp prepare_opts(opts) do
    opts
    |> Options.set_value(
      [:use_parentheses_with_zero_arity_functions],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end
end
