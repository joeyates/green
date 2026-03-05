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

  alias Green.Options

  @behaviour Green.Rule
  @rule_name :true_in_cond

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
        {:cond, cond_context, [[{{:__block__, do_context, [:do]}, clauses}]]} = node ->
          if cond_context[:line] in except_lines do
            node
          else
            last_match = get_in(clauses, last_match_path())

            if is_atom(last_match) do
              clauses = update_in(clauses, last_match_path(), fn _ -> true end)
              {:cond, cond_context, [[{{:__block__, do_context, [:do]}, clauses}]]}
            else
              node
            end
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

  defp last_match_path(), do: [at(-1), elem(2), at(0), at(0), elem(2), at(0)]
end
