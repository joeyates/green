defmodule Green.Rules.Linting.TrueInCond do
  @moduledoc """
  This rule ensures final, always-matching clauses in `cond` use `true`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      true_in_cond: [
        enabled: *true | false
      ]
    ]
  ```
  """
  import Access

  @behaviour Green.Rule

  alias Green.Options

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:true_in_cond][:enabled]
    do_apply({forms, comments}, enabled)
  end

  defp do_apply({forms, comments}, falsey) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy) do
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

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:true_in_cond],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end

  defp last_match_path(), do: [at(-1), elem(2), at(0), at(0), elem(2), at(0)]
end
