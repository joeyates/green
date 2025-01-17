defmodule ExCop.Quoted.Comments do
  @moduledoc """
  Conveniences for modifying parsed comments.
  """

  import ExCop.Quoted, only: [new_position: 3]

  def move_line(comments, from, to) do
    Enum.map(comments, fn comment ->
      line = new_position(comment.line, from, to)
      Map.put(comment, :line, line)
    end)
  end

  def sort(comments) do
    Enum.sort_by(comments, & &1[:line])
  end

  def line_comments(comments, line) do
    comments
    |> Enum.reverse()
    |> Enum.reduce(
      {line - 1, []},
      fn
        _comment, {nil, lines} ->
          {nil, lines}

        comment, {current, []} ->
          line = comment[:line]

          cond do
            line > current ->
              {current, []}

            line == current ->
              {current - 1, [line]}

            true ->
              {nil, []}
          end

        comment, {current, lines} ->
          line = comment[:line]

          if line == current do
            {current - 1, [line | lines]}
          else
            {nil, lines}
          end
      end
    )
    |> elem(1)
    |> Enum.reverse()
  end
end
