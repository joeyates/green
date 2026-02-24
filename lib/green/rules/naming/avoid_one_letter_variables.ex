defmodule Green.Rules.Naming.AvoidOneLetterVariables do
  @moduledoc """
  This module prints a warning if there are one-letter variable names.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      avoid_one_letter_variables: [
        enabled: *true | false
      ]
    ]
  ```
  """

  @behaviour Green.Rule

  alias Green.Options

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:avoid_one_letter_variables][:enabled]
    do_apply({forms, comments}, enabled, opts)
  end

  defp do_apply({forms, comments}, falsey, _opts) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy, opts) do
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

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:avoid_one_letter_variables],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end

  defp one_letter?(name) do
    name
    |> Atom.to_string()
    |> String.length()
    |> Kernel.==(1)
  end
end
