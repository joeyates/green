defmodule ExCop.Cops.Naming.AvoidOneLetterVariables do
  @moduledoc """
  This module prints a warning if there are one-letter variable names.
  """

  @behaviour ExCop.Cop

  @impl true
  def apply({forms, comments}, opts) do
    forms =
      Macro.prewalk(forms, fn
        {:_, _context, nil} = node ->
          node

        {name, context, nil} = node ->
          if one_letter?(name) do
            IO.warn(
              """
              one-letter variable name found
              #{context[:line]} | #{name}
              """,
              opts
            )
          end

          node

        other ->
          other
      end)

    {forms, comments}
  end

  defp one_letter?(name) do
    name
    |> Atom.to_string()
    |> String.length()
    |> Kernel.==(1)
  end
end
