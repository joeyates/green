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
end
