defmodule Green.Rules.Linting.BooleanOperators do
  @moduledoc """
  This rule checks for the use of `&&` and `||` in strictly boolean contexts and suggests using `and` and `or` instead.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      boolean_operators: [
        enabled: *true | false
      ]
    ]
  ```
  """

  alias Green.Rule
  alias Green.Options

  @behaviour Rule

  @impl Rule
  def apply(parsed, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:boolean_operators][:enabled]
    do_apply(parsed, enabled)
  end

  defp do_apply(parsed, falsey) when not falsey, do: parsed

  defp do_apply(parsed, _truthy) do
    Macro.prewalk(parsed, fn
      {operator, context, [left, right]} = node when operator in [:&&, :||] ->
        if boolean?(left) and boolean?(right) do
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
        if boolean?(arg) do
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
    Options.set_value(
      opts,
      [:boolean_operators],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end

  @boolean_comparisons ~w(== != === !== < <= > >=)a

  defp boolean?({:__block__, _context, [true]}), do: true
  defp boolean?({:__block__, _context, [false]}), do: true
  # All other values
  defp boolean?({:__block__, _context, _args}), do: false
  # Comparison operators, e.g. `name == :foo`
  defp boolean?({comparison, _context, _args}) when comparison in @boolean_comparisons, do: true

  # Module-scoped function call, e.g. `String.upcase(name)`
  defp boolean?(
    {
      {
        :.,
        _ctx1,
        [_module_or_aliases, fun]
      },
      _ctx3,
      _args
    }
  ) do
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
