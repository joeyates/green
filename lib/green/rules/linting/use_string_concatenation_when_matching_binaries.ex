defmodule Green.Rules.Linting.UseStringConcatenationWhenMatchingBinaries do
  @moduledoc """
  This rule replaces use of bitstrings with the `<>` operator when matching binaries.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      use_string_concatenation_when_matching_binaries: [
        enabled: *true | false
      ]
    ]
  ```
  """

  @behaviour Green.Rule

  alias Green.Options

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:use_string_concatenation_when_matching_binaries][:enabled]
    do_apply({forms, comments}, enabled)
  end

  defp do_apply({forms, comments}, falsey) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy) do
    forms =
      Macro.prewalk(forms, fn
        # Pattern matching in parameters
        {keyword, ctx1, [{:when, ctx2, [{name, ctx3, parameters} | guards]}, body]}
        when keyword in [:def, :defp] and is_list(parameters) ->
          parameters = Enum.map(parameters, &extract_concatenation/1)
          {keyword, ctx1, [{:when, ctx2, [{name, ctx3, parameters} | guards]}, body]}

        {keyword, ctx1, [{name, ctx2, parameters}, body]}
        when keyword in [:def, :defp] and is_list(parameters) ->
          parameters = Enum.map(parameters, &extract_concatenation/1)
          {keyword, ctx1, [{name, ctx2, parameters}, body]}

        # Pattern matching in assignment
        {:=, ctx1, [{:<<>>, _ctx2, _parts} = lhs, rhs]} ->
          {:=, ctx1, [extract_concatenation(lhs), rhs]}

        other ->
          other
      end)

    {forms, comments}
  end

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:use_string_concatenation_when_matching_binaries],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
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
