defmodule Green.Rules.Linting.TrueInCond do
  @moduledoc """
  This rule warns when final, always-matching clauses in `cond` do not use `true`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      true_in_cond: [
        enabled: *true | false,
        except: [
          "path/to/file.exs",
          {"path/to/other_file.exs", 42},
          {"path/to/yet_another_file.exs", [10, 20, 30]}
        ]
      ]
    ]
  ```

  ## Examples

      cond do
        is_list(param) ->
          :list

        :other ->
          :other
      end

  In the example above, the final clause should use `true` instead of `:other`.
  """
  import Access

  alias Green.Options

  @behaviour Green.Rule
  @rule_name :true_in_cond

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = get_in(opts, [:green, @rule_name, :enabled])

    if enabled do
      do_apply({forms, comments}, opts)
    end

    {forms, comments}
  end

  defp do_apply({forms, _comments}, opts) do
    except_lines = get_in(opts, [:green, @rule_name, :except_lines]) || []

    Macro.prewalk(forms, fn
      {:cond, cond_context, [[{{:__block__, _do_context, [:do]}, clauses}]]} = node ->
        if cond_context[:line] not in except_lines do
          last_match = get_in(clauses, last_match_path())

          if last_match != true and is_atom(last_match) do
            IO.warn(
              """
              cond final clause should use `true` instead of `#{inspect(last_match)}`
              #{cond_context[:line]} | cond do ... #{inspect(last_match)} -> ...
              """,
              opts
            )
          end
        end

        node

      other ->
        other
    end)
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
