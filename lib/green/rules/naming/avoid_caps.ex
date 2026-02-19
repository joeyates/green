defmodule Green.Rules.Naming.AvoidCaps do
  @moduledoc """
  This module prints warnings when capital letters are used in atoms, functions, variables or
  attributes.

  ## Configuration

  Acceptable capitalized atoms can be configured with the `accept_atoms` option.
  This can be set globally in the configuration file or per-file using a comment.

  In `.formatter.exs`:

  ```elixir
  green: [
    avoid_caps: [
      accept_atoms: [:Record, :MyApp.SpecialAtom]
    ]
  ]
  ```

  In a file:

  ```elixir
  # green:configure-for-this-file Naming.AvoidCaps, accept_atoms: [:Record]
  ```
  """

  @behaviour Green.Rule

  alias Green.Options

  @configuration_label "Naming.AvoidCaps"

  @impl true
  def apply({forms, comments}, opts) do
    file_opts = extract_config(comments)
    opts = prepare_opts(opts, file_opts)

    {forms, _acc} =
      Macro.traverse(
        forms,
        # `:is_attribute` is used to avoid double warnings -
        # without it, attributes with caps would raise a 'variable with caps' warning
        %{is_attribute: false},
        fn
          {:__block__, context, [atom]} = node, acc when is_atom(atom) ->
            if contains_caps?(atom, opts) do
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
            if contains_caps?(name, opts) do
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
            if contains_caps?(name, opts) do
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
            if contains_caps?(name, opts) do
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

  defp prepare_opts(opts, file_opts) do
    file_accept_atoms = get_in(file_opts, [:file_accept_atoms]) || []
    Options.set_value(opts, [:avoid_caps, :accept_atoms], &((&1 || []) ++ file_accept_atoms))
  end

  defp extract_config(comments) do
    accept_atoms_regex = ~r/
      \s*
      accept_atoms:
      \s*
      \[               # Start of list
        ([:\w_\. ,]+)  # Capture one or more atoms (with optional spaces and commas)
      \]               # End of list
    /x

    Enum.reduce(comments, %{file_accept_atoms: []}, fn
      %{text: "# green:configure-for-this-file #{@configuration_label}," <> rest}, acc ->
        match = Regex.run(accept_atoms_regex, rest, capture: :all_but_first)

        case match do
          nil ->
            acc

          [atom_list_string] ->
            atom_strings = extract_atom_names(atom_list_string)
            update_in(acc, [:file_accept_atoms], fn existing -> existing ++ atom_strings end)
        end

      _other_comment, acc ->
        acc
    end)
  end

  defp extract_atom_names(string) do
    case Regex.scan(~r/:([\w_\.]+)/, string, capture: :all_but_first) do
      nil -> []
      matches -> List.flatten(matches)
    end
  end

  @elixir_special_forms ~w(
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

  defp contains_caps?(term, _opts) when term in @elixir_special_forms, do: false

  defp contains_caps?(atom, opts) do
    accept_atoms = get_in(opts, [:green, :avoid_caps, :accept_atoms]) || []
    string = Atom.to_string(atom)

    if string in accept_atoms do
      false
    else
      string_contains_caps?(string)
    end
  end

  defp string_contains_caps?(string) do
    string
    |> String.codepoints()
    |> Enum.map(&first_char_code/1)
    |> Enum.any?(&capital?/1)
  end

  defp first_char_code(text) do
    <<code::utf8>> = text
    code
  end

  defp capital?(code) when code < ?A, do: false

  defp capital?(code) when code > ?Z, do: false

  defp capital?(_code), do: true
end
