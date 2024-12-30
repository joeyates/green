defmodule ExCop.Cops.Structs.RemoveNilFromStructDefinition do
  @moduledoc """
  This module removes `nil` defaults from struct definitions.
  """

  @behaviour ExCop.Cop

  @impl true
  def apply({forms, comments}, _opts) do
    forms =
      Macro.prewalk(forms, fn
        {:defstruct, context, right} = node ->
          if !nils?(right) do
            node
          else
            right = to_mixed_list(right)
            {:defstruct, context, right}
          end

        other ->
          other
      end)

    {forms, comments}
  end

  # Keyword
  defp nils?([items]) when is_list(items) do
    Enum.any?(items, &nil_keyword?/1)
  end

  # Mixed list
  defp nils?([{:__block__, _ctx, [items]}]) do
    Enum.any?(items, &nil_keyword?/1)
  end

  defp nil_keyword?({{:__block__, _ctx1, [_name]}, {:__block__, _ctx2, [nil]}}), do: true

  defp nil_keyword?(_node), do: false

  defp to_mixed_list([items]) when is_list(items) do
    first = hd(items)
    {{:__block__, context, [_name]}, {:__block__, _context, [_value]}} = first

    items =
      items
      |> Enum.map(&to_mixed_list_item/1)
      |> sort_atoms_first()

    [{:__block__, [line: context[:line]], [items]}]
  end

  defp to_mixed_list([{:__block__, context, [items]}]) do
    items =
      items
      |> Enum.map(&to_mixed_list_item/1)
      |> sort_atoms_first()

    [{:__block__, context, [items]}]
  end

  defp to_mixed_list_item(item) do
    if nil_keyword?(item) do
      {{:__block__, context, [name]}, {:__block__, _context, [nil]}} = item
      {:__block__, [line: context[:line]], [name]}
    else
      item
    end
  end

  defp sort_atoms_first(items) do
    Enum.sort(items, fn item1, item2 ->
      cond do
        keyword?(item1) && keyword?(item2) ->
          true

        keyword?(item1) ->
          false

        true ->
          true
      end
    end)
  end

  defp keyword?({:__block__, _context, [name]}) when is_atom(name), do: false

  defp keyword?({{:__block__, _ctx1, [_name]}, {:__block__, _ctx2, [_value]}}), do: true
end
