defmodule Green.Rules.Linting.BooleanOperators do
  @moduledoc """
  This rule checks for the use of `&&` and `||` in strictly boolean contexts and suggests using `and` and `or` instead.
  """

  alias Green.Rule

  @behaviour Rule
  
  @impl Rule
  def apply(parsed, _opts) do
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
        [{:__aliases__, _ctx2, _namespace}, fun]
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