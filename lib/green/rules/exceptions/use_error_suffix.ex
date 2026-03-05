defmodule Green.Rules.Exceptions.UseErrorSuffix do
  @moduledoc """
  This rule warns if exceptions are defined with a suffix of `Error`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      use_error_suffix: [
        enabled: *true | false,
        except: [
          "path/to/file.exs",
          {"path/to/other_file.exs", 42},
          {"path/to/yet_another_file.exs", [10, 20, 30]}
        ]
      ]
    ]
  ```

  ## Examples

      defmodule MyBad do
        defexception message: "some error message"
      end

  In the example above, the exception should be named `MyBadError`.
  """

  @behaviour Green.Rule
  @rule_name :use_error_suffix

  alias Green.Options

  @impl true
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

    {_forms, _acc} =
      Macro.traverse(
        forms,
        %{exception: false},
        fn
          {:defexception, _context, _right} = node, acc ->
            {node, Map.put(acc, :exception, true)}

          other, acc ->
            {other, acc}
        end,
        fn
          {:defmodule, context, [{:__aliases__, _context, modules} | _rest]} = node,
          %{exception: true} = acc ->
            name = modules |> Enum.at(-1) |> Atom.to_string()

            if !String.ends_with?(name, "Error") and context[:line] not in except_lines do
              IO.warn(
                """
                exception #{name} should have a suffix of `Error`
                #{context[:line]} | #{name}
                """,
                opts
              )
            end

            {node, Map.put(acc, :exception, false)}

          other, acc ->
            {other, acc}
        end
      )
  end

  defp prepare_opts(opts) do
    opts
    |> Options.set_value(
      [@rule_name],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end
end
