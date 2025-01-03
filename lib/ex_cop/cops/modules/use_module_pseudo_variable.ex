defmodule ExCop.Cops.Modules.UseModulePseudoVariable do
  @moduledoc """
  This cop replaces references to the current module by name with the pseudo-variable
  `__MODULE__`.
  """

  @behaviour ExCop.Cop

  @impl true
  def apply({forms, comments}, _opts) do
    {forms, _acc} =
      Macro.traverse(
        forms,
        %{},
        fn
          {:defmodule, context, [{:__aliases__, _context, module} | _rest]} = node, _acc ->
            {node, %{module: module, line: context[:line]}}

          {:defmacro, _context, _right} = node, acc ->
            {node, Map.put(acc, :in_macro, true)}

          {:__aliases__, _context, _module} = node, %{in_macro: true} = acc ->
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

          {:defmacro, _context, _right} = node, acc ->
            {node, Map.delete(acc, :in_macro)}

          other, acc ->
            {other, acc}
        end
      )

    {forms, comments}
  end
end
