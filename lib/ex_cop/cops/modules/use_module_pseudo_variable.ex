defmodule ExCop.Cops.Modules.UseModulePseudoVariable do
  @moduledoc """
  This cop replaces references to the current module by name with the pseudo-variable
  `__MODULE__`.
  """
  def apply({forms, comments}) do
    {forms, _acc} =
      Macro.traverse(
        forms,
        %{},
        fn
          {:defmodule, context, right} = node, _acc ->
            {:__aliases__, _context, module} = hd(right)
            {node, %{module: module, line: context[:line]}}

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
          {:defmodule, _context, _right} = node, _acc ->
            {node, %{}}

          other, acc ->
            {other, acc}
        end
      )

    {forms, comments}
  end
end
