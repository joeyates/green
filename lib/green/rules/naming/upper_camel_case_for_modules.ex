defmodule Green.Rules.Naming.UpperCamelCaseForModules do
  @moduledoc """
  This rule checks that module names use UpperCamelCase.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      upper_camel_case_for_modules: [
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

  alias Green.Rule
  alias Green.Options

  @behaviour Rule
  @rule_name :upper_camel_case_for_modules

  @impl Rule
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = get_in(opts, [:green, @rule_name, :enabled])

    if enabled do
      do_apply({forms, comments}, opts)
    end

    {forms, comments}
  end

  defp do_apply({forms, _comments}, opts) do
    except_lines = get_in(opts, [:green, @rule_name, :except_lines]) || []

    Macro.prewalk(
      forms,
      fn
        {:defmodule, _ctx1, [{:__aliases__, context, modules} = first | _rest]} = node ->
          if not Enum.all?(modules, &upper_camel_case?/1) and context[:line] not in except_lines do
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
          if not upper_camel_case?(module) and context[:line] not in except_lines do
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
  end

  defp prepare_opts(opts) do
    opts
    |> Options.set_value(
      [:upper_camel_case_for_modules],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end

  defp upper_camel_case?(atom) do
    atom
    |> Atom.to_string()
    |> String.match?(~r/^[A-Z][a-zA-Z0-9]*$/)
  end
end
