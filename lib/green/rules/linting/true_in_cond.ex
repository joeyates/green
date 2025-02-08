defmodule Green.Rules.Linting.TrueInCond do
  @moduledoc """
  This cop ensures final, always-matching clauses in `cond` use `true`.
  """
  import Access

  @behaviour Green.Rule

  @impl true
  def apply({forms, comments}, _opts) do
    forms =
      Macro.prewalk(forms, fn
        {:cond, cond_context, [[{{:__block__, do_context, [:do]}, clauses}]]} ->
          last_match = get_in(clauses, last_match_path())

          clauses =
            if is_atom(last_match) do
              update_in(clauses, last_match_path(), fn _ -> true end)
            else
              clauses
            end

          {:cond, cond_context, [[{{:__block__, do_context, [:do]}, clauses}]]}

        other ->
          other
      end)

    {forms, comments}
  end

  defp last_match_path(), do: [at(-1), elem(2), at(0), at(0), elem(2), at(0)]
end
