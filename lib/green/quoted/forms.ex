defmodule Green.Quoted.Forms do
  @moduledoc """
  Conveniences for modifying the AST.
  """

  import Green.Quoted, only: [shift: 4]

  def move_line(forms, from, to) do
    Macro.prewalk(forms, fn
      {left, context, right} ->
        context =
          context
          |> shift([:line], from, to)
          |> shift([:closing, :line], from, to)

        {left, context, right}

      node ->
        node
    end)
  end
end
