defmodule Green.Rules.Modules.UseModulePseudoVariable do
  @moduledoc """
  This rule replaces references to the current module by name with the pseudo-variable
  `__MODULE__`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      use_module_pseudo_variable: [
        enabled: *true | false,
        except: [
          "path/to/file.exs",
          {"path/to/other_file.exs", 42},
          {"path/to/yet_another_file.exs", [10, 20, 30]}
        ]
      ]
    ]
  ```
  """

  @behaviour Green.Rule
  @rule_name :use_module_pseudo_variable

  alias Green.Options

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:use_module_pseudo_variable][:enabled]
    do_apply({forms, comments}, enabled, opts)
  end

  defp do_apply({forms, comments}, falsey, _opts) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy, opts) do
    except_lines = opts[:green][:use_module_pseudo_variable][:except_lines] || []

    {forms, _acc} =
      Macro.traverse(
        forms,
        %{except_lines: except_lines},
        fn
          {:defmodule, context, [{:__aliases__, _context, module} | _rest]} = node, acc ->
            {node, Map.merge(acc, %{module: module, line: context[:line]})}

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
              if context[:line] != acc[:line] and context[:line] not in acc[:except_lines] do
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
    opts
    |> Options.set_value(
      [:use_module_pseudo_variable],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end
end
