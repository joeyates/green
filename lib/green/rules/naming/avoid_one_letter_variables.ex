defmodule Green.Rules.Naming.AvoidOneLetterVariables do
  @moduledoc """
  This module prints a warning if there are one-letter variable names.
  """

  @behaviour Green.Rule

  @impl true
  def apply({forms, comments}, opts) do
    Macro.traverse(
      forms,
      %{in_type: false},
      fn
        {:@, _ctx1, [{:type, _ctx2, _right}]} = node, acc ->
          {node, Map.put(acc, :in_type, true)}

        node, %{in_type: true} = acc ->
          {node, acc}

        {:_, _context, nil} = node, acc ->
          {node, acc}

        {name, context, nil} = node, acc ->
          if one_letter?(name) do
            IO.warn(
              """
              one-letter variable name found
              #{context[:line]} | #{name}
              """,
              opts
            )
          end

          {node, acc}

        other, acc ->
          {other, acc}
      end,
      fn
        {:@, _ctx1, [{:type, _ctx2, _right}]} = node, acc ->
          {node, Map.delete(acc, :in_type)}

        other, acc ->
          {other, acc}
      end
    )

    {forms, comments}
  end

  defp one_letter?(name) do
    name
    |> Atom.to_string()
    |> String.length()
    |> Kernel.==(1)
  end
end
