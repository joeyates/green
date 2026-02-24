defmodule Green.Rules.Structs.RemoveNilFromStructDefinition do
  @moduledoc """
  This module removes `nil` defaults from struct definitions.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      remove_nil_from_struct_definition: [
        enabled: *true | false
      ]
    ]
  ```
  """

  alias Green.Quoted.{Comments, FormsAndComments}
  alias Green.Options

  @behaviour Green.Rule

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:remove_nil_from_struct_definition][:enabled]
    do_apply({forms, comments}, enabled)
  end

  defp do_apply({forms, comments}, falsey) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy) do
    Macro.prewalk(forms, comments, fn
      {:defstruct, ctx1, [{:__block__, ctx2, [items]}]} = node, comments when is_list(items) ->
        if nils?(items) do
          {items, comments} = to_mixed_list(items, comments)
          {{:defstruct, ctx1, [{:__block__, ctx2, [items]}]}, comments}
        else
          {node, comments}
        end

      {:defstruct, context, [items]} = node, comments when is_list(items) ->
        if nils?(items) do
          {items, comments} = to_mixed_list(items, comments)
          {{:defstruct, context, [{:__block__, context, [items]}]}, comments}
        else
          {node, comments}
        end

      other, comments ->
        {other, comments}
    end)
  end

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:remove_nil_from_struct_definition],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end

  defp nils?(items) do
    Enum.any?(items, &nil_keyword?/1)
  end

  defp to_mixed_list(items, comments) do
    next_line =
      items
      |> first_keyword()
      |> line()

    {items, comments, _next_line} =
      items
      |> Enum.with_index()
      |> Enum.reduce(
        {items, comments, next_line},
        fn {item, index}, {items, comments, next_line} ->
          if nil_keyword?(item) do
            name = name(item)
            line = line(item)
            item = {:__block__, [line: line], [name]}
            items = update_in(items, [Access.at(index)], fn _ -> item end)
            {items, comments} = FormsAndComments.move({items, comments}, line, next_line)
            {items, comments, next_line + 1}
          else
            {items, comments, next_line}
          end
        end
      )

    items = atoms_first(items)
    comments = Comments.sort(comments)

    {items, comments}
  end

  defp atoms_first(items) do
    items
    |> Enum.with_index()
    |> Enum.sort(&compare/2)
    |> Enum.map(&elem(&1, 0))
  end

  defp compare(
         {{{:__block__, _ctx1, [_name1]}, _value1}, index1},
         {{{:__block__, _ctx2, [_name2]}, _value2}, index2}
       ) do
    # Don't sort keywords
    index1 < index2
  end

  defp compare(
         {{:__block__, _ctx1, [_key1]}, _index1},
         {{{:__block__, _ctx2, [_name2]}, _value2}, _index2}
       ) do
    true
  end

  defp compare(
         {{{:__block__, _ctx1, [_name1]}, _value1}, _index1},
         {{:__block__, _ctx2, [_key2]}, _index2}
       ) do
    false
  end

  defp compare({{:__block__, _ctx1, [_key1]}, index1}, {{:__block__, _ctx2, [_key2]}, index2}) do
    # Don't sort atoms
    index1 < index2
  end

  defp first_keyword(items), do: Enum.find(items, &keyword?/1)

  defp keyword?({{:__block__, _ctx, [name]}, _value}) when is_atom(name), do: true

  defp keyword?(_node), do: false

  defp nil_keyword?({{:__block__, _ctx1, [_name]}, {:__block__, _ctx2, [nil]}}), do: true

  defp nil_keyword?(_node), do: false

  defp name(item) do
    {{:__block__, _ctx1, [name]}, {:__block__, _ctx2, [nil]}} = item
    name
  end

  defp line({{:__block__, ctx, [_name]}, _value}), do: ctx[:line]

  defp line({:__block__, ctx, [_name]}), do: ctx[:line]
end
