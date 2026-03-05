defmodule Green.Rules.Linting.UseStringConcatenationWhenMatchingBinaries do
  @moduledoc """
  This rule replaces use of bitstrings with the `<>` operator when matching binaries.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      use_string_concatenation_when_matching_binaries: [
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
  @rule_name :use_string_concatenation_when_matching_binaries

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
        # Pattern matching in parameters
        {keyword, ctx1, [{:when, ctx2, [{name, ctx3, parameters} | guards]}, body]} = node
        when keyword in [:def, :defp] and is_list(parameters) ->
          if ctx3[:line] in except_lines do
            node
          else
            parameters = Enum.map(parameters, &extract_concatenation/1)
            {keyword, ctx1, [{:when, ctx2, [{name, ctx3, parameters} | guards]}, body]}
          end

        {keyword, ctx1, [{name, ctx2, parameters}, body]} = node
        when keyword in [:def, :defp] and is_list(parameters) ->
          if ctx2[:line] in except_lines do
            node
          else
            parameters = Enum.map(parameters, &extract_concatenation/1)
            {keyword, ctx1, [{name, ctx2, parameters}, body]}
          end

        # Pattern matching in assignment
        {:=, ctx1, [{:<<>>, _ctx2, _parts} = lhs, rhs]} = node ->
          if ctx1[:line] in except_lines do
            node
          else
            {:=, ctx1, [extract_concatenation(lhs), rhs]}
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

  defp extract_concatenation({:<<>>, context, []}), do: {:__block__, context, [""]}

  defp extract_concatenation({:<<>>, context, entries}) do
    entries
    |> to_stretches()
    |> wrap_entries(context)
    |> join_stretches(context)
  end

  defp extract_concatenation(other), do: other

  defp to_stretches(entries) do
    entries
    |> Enum.reverse()
    |> Enum.reduce(
      [],
      fn
        entry, [] ->
          case variable_or_string(entry) do
            nil ->
              [[entry]]

            variable ->
              [variable]
          end

        entry, [first | rest] = stretches ->
          case variable_or_string(entry) do
            nil ->
              if is_list(first) do
                [[entry | first] | rest]
              else
                [[entry] | stretches]
              end

            variable ->
              [variable | stretches]
          end
      end
    )
  end

  defp wrap_entries(stretches, context) do
    Enum.map(stretches, &wrap_entry(&1, context))
  end

  defp wrap_entry(term, context) when is_list(term) do
    {:<<>>, context, term}
  end

  defp wrap_entry(term, _context), do: term

  defp join_stretches([term], _context), do: term

  defp join_stretches(stretches, context) do
    stretches
    |> Enum.reverse()
    |> Enum.reduce(
      nil,
      fn
        stretch, nil ->
          stretch

        stretch, acc ->
          {:<>, context, [stretch, acc]}
      end
    )
  end

  defp variable_or_string({:"::", ctx1, [{name, _ctx2, nil}, {type, _ctx3, _}]})
       when type in [:binary, :bytes] do
    {name, ctx1, nil}
  end

  defp variable_or_string({:__block__, _ctx, [string]}) when is_binary(string), do: string

  defp variable_or_string(_), do: nil
end
