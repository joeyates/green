defmodule ExCop.Cops.Modules.SortReferences do
  @module_reference_types [:use, :import, :alias, :require]

  def apply({forms, comments}) do
    {lines_by_type, min_line} = initial_positions(forms)

    {forms, comments, lines_by_type} = reorder({forms, comments, lines_by_type, min_line})
    forms = set_blank_lines(forms, lines_by_type)

    {forms, comments}
  end

  defp initial_positions(forms) do
    {lines, min_line} =
      forms
      |> get_in(module_lines_access())
      |> Enum.reduce(
        {%{}, nil},
        fn
          {type, context, _block}, {lines, min_line} when type in @module_reference_types ->
            line = context[:line]
            min_line = min_line || line
            min_line = min(min_line, line)
            lines = Map.update(lines, type, [line], &[line | &1])
            {lines, min_line}

          _node, acc ->
            acc
        end
      )

    lines =
      lines
      |> Enum.map(fn {type, lines} -> {type, Enum.reverse(lines)} end)
      |> Enum.into(%{})

    {lines, min_line}
  end

  defp reorder({forms, comments, lines_by_type, min_line}) do
    {forms, comments, lines_by_type, _current_line} =
      @module_reference_types
      |> Enum.reduce(
        {forms, comments, lines_by_type, min_line},
        fn type, {forms, comments, lines_by_type, current_line} ->
          lines = lines_by_type[type] || []

          lines
          |> Enum.reduce(
            {forms, comments, lines_by_type, current_line},
            fn line, {forms, comments, lines_by_type, current_line} ->
              {forms, comments, lines_by_type} =
                renumber({forms, comments, lines_by_type}, line, current_line)

              {forms, comments} = sort({forms, comments})

              {forms, comments, lines_by_type, current_line + 1}
            end
          )
        end
      )

    {forms, comments, lines_by_type}
  end

  defp set_blank_lines(forms, lines_by_type) do
    {forms, _acc} =
      Macro.prewalk(forms, %{}, fn
        {type, context, right}, seen when type in @module_reference_types ->
          line = context[:line]

          if line do
            seen =
              update_in(seen, [type], fn
                nil -> [line]
                lines -> [line | lines]
              end)

            last = length(lines_by_type[type]) == length(seen[type])
            newlines = if last, do: 2, else: 1
            # TODO: This assumes the expression lasts one line
            last_line = line

            context =
              Keyword.put(context, :end_of_expression, newlines: newlines, line: last_line)

            {{type, context, right}, seen}
          else
            {{type, context, right}, seen}
          end

        node, seen ->
          {node, seen}
      end)

    forms
  end

  defp renumber(refs, from, from), do: refs

  defp renumber({forms, comments, lines_by_type}, from, to) do
    forms =
      Macro.prewalk(forms, fn
        {left, context, right} ->
          line = context[:line]

          if line do
            moved = new_position(line, from, to)

            {left, Keyword.put(context, :line, moved), right}
          else
            {left, context, right}
          end

        node ->
          node
      end)

    comments =
      Enum.map(comments, fn comment ->
        line = new_position(comment.line, from, to)
        Map.put(comment, :line, line)
      end)

    lines_by_type =
      lines_by_type
      |> Enum.map(fn {type, lines} ->
        {type, Enum.map(lines, &new_position(&1, from, to))}
      end)

    {forms, comments, lines_by_type}
  end

  defp sort({forms, comments}) do
    forms =
      update_in(forms, module_lines_access(), fn lines ->
        Enum.sort_by(lines, &get_in(&1, [Access.elem(1), :line]))
      end)

    comments = Enum.sort_by(comments, & &1[:line])
    {forms, comments}
  end

  defp new_position(current, from, to) when from > to do
    cond do
      current < to -> current
      current > from -> current
      current == from -> to
      true -> current + 1
    end
  end

  defp new_position(current, from, to) when from < to do
    cond do
      current < from -> current
      current > to -> current
      current == from -> to
      true -> current - 1
    end
  end

  defp new_position(current, _from, _to), do: current

  defp module_lines_access do
    [
      Access.elem(2),
      Access.at(1),
      Access.at(0),
      Access.elem(1),
      Access.elem(2)
    ]
  end
end
