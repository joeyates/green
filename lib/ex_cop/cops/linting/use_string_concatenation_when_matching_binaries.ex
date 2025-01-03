defmodule ExCop.Cops.Linting.UseStringConcatenationWhenMatchingBinaries do
  @moduledoc """
  This cop replaces use of bitstrings with the `<>` operator when matching binaries.
  """

  @behaviour ExCop.Cop

  @impl true
  def apply({forms, comments}, _opts) do
    forms =
      Macro.prewalk(forms, fn
        # Pattern matching in parameters
        {:def, _context1, [{_name, _context2, nil}, _body]} = node ->
          node

        {:def, context1, [{name, context2, parameters}, body]} ->
          parameters = Enum.map(parameters, &binary_parts_to_concatenation/1)
          {:def, context1, [{name, context2, parameters}, body]}

        # Pattern matching in assignment
        {:=, context, [{:<<>>, _context2, _parts} = lhs, rhs]} ->
          lhs = binary_parts_to_concatenation(lhs)
          {:=, context, [lhs, rhs]}

        other ->
          other
      end)

    {forms, comments}
  end

  defp binary_parts_to_concatenation({:<<>>, context, parts}) do
    parts = Enum.map(parts, &to_concatenated_part/1)
    {:<>, context, parts}
  end

  defp binary_parts_to_concatenation(other), do: other

  # param::bytes -> param
  defp to_concatenated_part({:"::", context, [{param, context, nil}, {:bytes, context, nil}]}) do
    {param, context, nil}
  end

  # param::other -> <<param::other>>
  defp to_concatenated_part({:"::", context, _binary} = node) do
    {:<<>>, context, [node]}
  end

  defp to_concatenated_part(part) do
    part
  end
end
