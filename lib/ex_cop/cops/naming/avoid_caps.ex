defmodule ExCop.Cops.Naming.AvoidCaps do
  @moduledoc """
  This module prints warnings when capital letters are used in atoms, functions, variables or
  attributes.
  """

  @behaviour ExCop.Cop

  @impl true
  def apply({forms, comments}, opts) do
    {forms, _acc} =
      Macro.traverse(
        forms,
        # `:is_attribute` is used to avoid double warnings -
        # without it, attributes with caps would raise a 'variable with caps' warning
        %{is_attribute: false},
        fn
          {:__block__, context, [atom]} = node, acc when is_atom(atom) ->
            if contains_caps?(atom) do
              IO.warn(
                """
                capital letter found in atom (use snake_case for atoms)
                #{context[:line]} | #{inspect(atom)}
                """,
                opts
              )
            end

            {node, acc}

          {:def, context, [{name, _context2, _params}, _body]} = node, acc when is_atom(name) ->
            if contains_caps?(name) do
              IO.warn(
                """
                capital letter found in function name (use snake_case for function names)
                #{context[:line]} | #{name}
                """,
                opts
              )
            end

            {node, acc}

          {name, context, nil} = node, %{is_attribute: false} = acc when is_atom(name) ->
            if contains_caps?(name) do
              IO.warn(
                """
                capital letter found in variable name (use snake_case for variable names)
                #{context[:line]} | #{name}
                """,
                opts
              )
            end

            {node, acc}

          {:@, context, [{name, _context2, _expression}]} = node, acc ->
            if contains_caps?(name) do
              IO.warn(
                """
                capital letter found in attribute name (use snake_case for attribute names)
                #{context[:line]} | @#{name}
                """,
                opts
              )
            end

            {node, Map.put(acc, :is_attribute, true)}

          other, acc ->
            {other, acc}
        end,
        fn
          {:@, _context, [{_name, _context2, _expression}]} = node, acc ->
            {node, Map.put(acc, :is_attribute, false)}

          other, acc ->
            {other, acc}
        end
      )

    {forms, comments}
  end

  @elixir_variables ~w(
    Elixir
    __CALLER__
    __DIR__
    __ENV__
    __FILE__
    __MODULE__
    __STACKTRACE__
    DOWN
    EXIT
  )a

  defp contains_caps?(term) when term in @elixir_variables, do: false

  defp contains_caps?(atom) do
    atom
    |> Atom.to_string()
    |> String.codepoints()
    |> Enum.map(&first_char_code/1)
    |> Enum.any?(&capital?/1)
  end

  defp first_char_code(text) do
    <<code::utf8>> = text
    code
  end

  def capital?(code) when code < ?A, do: false

  def capital?(code) when code > ?Z, do: false

  def capital?(_code), do: true
end
