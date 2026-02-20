defmodule Green.Rules.Naming.UpperCamelCaseForModules do
  @moduledoc """
  This rule checks that module names use UpperCamelCase.
  """

  alias Green.Rule

  @behaviour Rule

  @impl Rule
  def apply({forms, comments}, opts) do
    Macro.prewalk(
      forms,
      fn
        {:defmodule, _ctx1, [{:__aliases__, context, modules} = first | _rest]} = node ->
          if !Enum.all?(modules, &upper_camel_case?/1) do
            IO.warn(
              """
              found badly formed module name (use UpperCamelCase for module names)
              #{context[:line]} | defmodule #{Macro.to_string(first)} do
              """,
              opts
            )
          end

          node

        # Handle the case where the module name is an atom (e.g., `defmodule :appStack`)
        {:defmodule, _ctx1, [{:__block__, context, [module]} = first | _rest]} = node ->
          if !upper_camel_case?(module) do
            IO.warn(
              """
              found badly formed module name (use UpperCamelCase for module names)
              #{context[:line]} | defmodule #{Macro.to_string(first)} do
              """,
              opts
            )
          end

          node

        other ->
          other
      end
    )

    {forms, comments}
  end

  defp upper_camel_case?(atom) do
    atom
    |> Atom.to_string()
    |> String.match?(~r/^[A-Z][a-zA-Z0-9]*$/)
  end
end
