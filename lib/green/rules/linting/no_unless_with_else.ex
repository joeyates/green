defmodule Green.Rules.Linting.NoUnlessWithElse do
  @moduledoc """
  This rule transforms `unless` with `else` into `if` with `else`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      no_unless_with_else: [
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
  @rule_name :no_unless_with_else

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

    forms =
      Macro.prewalk(forms, fn
        {:unless, context,
         [
           condition,
           [
             {{:__block__, ctx1, [:do]}, do_expression},
             {{:__block__, ctx2, [:else]}, else_expression}
           ]
         ]} = node ->
          if context[:line] in except_lines do
            node
          else
            {:if, context,
             [
               condition,
               [
                 {{:__block__, ctx1, [:do]}, else_expression},
                 {{:__block__, ctx2, [:else]}, do_expression}
               ]
             ]}
          end

        other ->
          other
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
