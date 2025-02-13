defmodule Green.Rules.Exceptions.UseErrorSuffix do
  @moduledoc """
  This rule warns if exceptions are defined with a suffix of `Error`.

  ## Examples

      defmodule MyBad do
        defexception message: "some error message"
      end

  In the example above, the exception should be named `MyBadError`.
  """

  @behaviour Green.Rule

  @impl true
  def apply({forms, comments}, opts) do
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
end
