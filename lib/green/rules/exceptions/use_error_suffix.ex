defmodule Green.Rules.Exceptions.UseErrorSuffix do
  @moduledoc """
  This rule warns if exceptions are defined with a suffix of `Error`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      use_error_suffix: [
        enabled: *true | false
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

  alias Green.Options

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:use_error_suffix][:enabled]
    do_apply({forms, comments}, enabled, opts)
  end

  defp do_apply({forms, comments}, falsey, _opts) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy, opts) do
    {forms, _acc} =
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

            if !String.ends_with?(name, "Error") do
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

    {forms, comments}
  end

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:use_error_suffix],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end
end
