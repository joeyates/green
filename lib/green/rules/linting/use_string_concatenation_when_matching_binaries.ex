defmodule Green.Rules.Linting.UseStringConcatenationWhenMatchingBinaries do
  @moduledoc """
  This cop replaces use of bitstrings with the `<>` operator when matching binaries.
  """

  @behaviour Green.Rule

  @impl true
  def apply({forms, comments}, _opts) do
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
