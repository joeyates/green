defmodule Green.Rules.Modules.UseModulePseudoVariable do
  @moduledoc """
  This rule replaces references to the current module by name with the pseudo-variable
  `__MODULE__`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      use_module_pseudo_variable: [
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
    enabled = opts[:green][:use_module_pseudo_variable][:enabled]
    do_apply({forms, comments}, enabled)
  end

  defp do_apply({forms, comments}, falsey) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy) do
    {forms, _acc} =
      Macro.traverse(
        forms,
        %{},
        fn
          {:defmodule, context, [{:__aliases__, _context, module} | _rest]} = node, _acc ->
            {node, %{module: module, line: context[:line]}}

          {:defimpl, _context, _right} = node, acc ->
            {node, Map.put(acc, :in_defimpl, true)}

          {:defmacro, _context, _right} = node, acc ->
            {node, Map.put(acc, :in_macro, true)}

          {:quote, _context, _right} = node, acc ->
            {node, Map.put(acc, :in_quote, true)}

          {:__aliases__, _context, _module} = node, %{in_defimpl: true} = acc ->
            {node, acc}

          {:__aliases__, _context, _module} = node, %{in_macro: true} = acc ->
            {node, acc}

          {:__aliases__, _context, _module} = node, %{in_quote: true} = acc ->
            {node, acc}

          {:__aliases__, context, module}, %{module: module} = acc ->
            # The module name should only appear on the line with `defmodule`
            module =
              if context[:line] != acc[:line] do
                [:__MODULE__]
              else
                module
              end

            {{:__aliases__, context, module}, acc}

          other, acc ->
            {other, acc}
        end,
        fn
          {:defmodule, _context, _right} = node, acc ->
            {node, Map.drop(acc, [:module, :line])}

          {:defimpl, _context, _right} = node, acc ->
            {node, Map.delete(acc, :in_defimpl)}

          {:defmacro, _context, _right} = node, acc ->
            {node, Map.delete(acc, :in_macro)}

          {:quote, _context, _right} = node, acc ->
            {node, Map.delete(acc, :in_quote)}

          other, acc ->
            {other, acc}
        end
      )

    {forms, comments}
  end

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:use_module_pseudo_variable],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end
end
