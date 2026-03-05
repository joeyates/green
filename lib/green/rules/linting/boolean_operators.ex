defmodule Green.Rules.Linting.BooleanOperators do
  @moduledoc """
  This rule checks for the use of `&&` and `||` in strictly boolean contexts and suggests using `and` and `or` instead.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      boolean_operators: [
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
  @rule_name :boolean_operators

  @impl Rule
  def apply(parsed, opts) do
    opts = prepare_opts(opts)
    rule_opts = get_in(opts, [:green, @rule_name]) || []

    if rule_opts[:enabled] do
      do_apply(parsed, rule_opts)
    else
      parsed
    end
  end

  defp do_apply(parsed, rule_opts) do
    except_lines = rule_opts[:except_lines] || []

    Macro.prewalk(parsed, fn
      {operator, context, [left, right]} = node when operator in [:&&, :||] ->
        if context[:line] not in except_lines and boolean?(left) and boolean?(right) do
          suggested_operator = if operator == :&&, do: :and, else: :or

          IO.warn(
            """
            use `#{suggested_operator}` instead of `#{operator}` for boolean checks
            #{context[:line]} | #{Macro.to_string(node)}
            """,
            []
          )
        end

        node

      {:!, context, [arg]} = node ->
        if context[:line] not in except_lines and boolean?(arg) do
          IO.warn(
            """
            use `not` instead of `!` for boolean checks
            #{context[:line]} | #{Macro.to_string(node)}
            """,
            []
          )
        end

        node

      other ->
        other
    end)

    parsed
  end

  defp prepare_opts(opts) do
    opts
    |> Options.set_value(
      [@rule_name],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end

  @boolean_comparisons ~w(== != === !== < <= > >=)a

  defp boolean?({:__block__, _context, [true]}), do: true
  defp boolean?({:__block__, _context, [false]}), do: true
  # All other values
  defp boolean?({:__block__, _context, _args}), do: false
  # Comparison operators, e.g. `name == :foo`
  defp boolean?({comparison, _context, _args}) when comparison in @boolean_comparisons, do: true

  # Module-scoped function call, e.g. `String.upcase(name)`
  defp boolean?({
         {
           :.,
           _ctx1,
           [_module_or_aliases, fun]
         },
         _ctx3,
         _args
       }) do
    name = Atom.to_string(fun)
    guard_style?(name) or predicate?(name)
  end

  # Local function call
  defp boolean?({fun, _context, _args}) do
    name = Atom.to_string(fun)
    guard_style?(name) or predicate?(name)
  end

  defp guard_style?(name) do
    String.starts_with?(name, ["is_", "has_"])
  end

  defp predicate?(name) do
    String.ends_with?(name, "?")
  end
end
