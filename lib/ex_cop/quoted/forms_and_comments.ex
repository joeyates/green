defmodule ExCop.Quoted.FormsAndComments do
  @moduledoc """
  Conveniences for modifying the AST and associated comments.
  """

  alias ExCop.Quoted.{Comments, Forms}

  @doc """
  Move a line in the AST and associated comments.

  Any comments immediately preceding the given line are moved to
  the given destination `to` line. The line itself is moved to
  the following line.
  """
  def move({forms, comments}, from, to) do
    {forms, comments, to} =
      comments
      |> Comments.line_comments(from)
      |> Enum.reduce(
        {forms, comments, to},
        fn comment_line, {forms, comments, to} ->
          forms = Forms.move_line(forms, comment_line, to)
          comments = Comments.move_line(comments, comment_line, to)
          {forms, comments, to + 1}
        end
      )

    forms = Forms.move_line(forms, from, to)
    comments = Comments.move_line(comments, from, to)
    {forms, comments}
  end
end
