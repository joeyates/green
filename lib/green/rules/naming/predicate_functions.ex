defmodule Green.Rules.Naming.PredicateFunctions do
  @moduledoc """
  This rule checks that predicate functions have `?` suffix and guard-style macros use `is_` prefix.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      predicate_functions: [
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

  alias Green.Rule
  alias Green.Options

  @behaviour Rule
  @rule_name :predicate_functions

  @function_definition_keywords [:def, :defp]
  @macro_definition_keywords [:defmacro, :defmacrop]

  @impl Rule
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:predicate_functions][:enabled]
    do_apply({forms, comments}, enabled, opts)
  end

  defp do_apply({forms, comments}, falsey, _opts) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy, opts) do
    except_lines = opts[:green][:predicate_functions][:except_lines] || []

    Macro.prewalk(
      forms,
      fn
        {keyword, context, [{name, _, _} = left | _]} = node
        when keyword in @function_definition_keywords and is_atom(name) ->
          if guard_style?(name) and context[:line] not in except_lines do
            IO.warn(
              """
              predicate function should have `?` suffix
              #{context[:line]} | #{keyword} #{Macro.to_string(left)} do
              """,
              opts
            )
          end

          node

        {keyword, context, [{name, _, _} = left | _]} = node
        when keyword in @macro_definition_keywords ->
          if final_question_mark?(name) and context[:line] not in except_lines do
            IO.warn(
              """
              guard-style macros should not have `?` suffix, use `is_` prefix instead
              #{context[:line]} | #{keyword} #{Macro.to_string(left)} do
              """,
              opts
            )
          end

          node

        other ->
          other
      end
    )

    {forms, comments}
  end

  defp prepare_opts(opts) do
    opts
    |> Options.set_value(
      [:predicate_functions],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end

  defp guard_style?(name) do
    name
    |> to_string()
    |> String.starts_with?("is_")
  end

  defp final_question_mark?(name) do
    name
    |> to_string()
    |> String.ends_with?("?")
  end
end
