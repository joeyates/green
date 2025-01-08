defmodule ExCop.Cops.Exceptions.UseErrorSuffix do
  @moduledoc """
  This cop warns if exceptions are defined with a suffix of `Error`.

  ## Examples

      defmodule MyBad do
        defexception message: "some error message"
      end

  In the example above, the exception should be named `MyBadError`.
  """

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
          {:defmodule, context, right} = node, %{exception: true} = acc ->
            {:__aliases__, _context, [module]} = hd(right)
            name = Atom.to_string(module)

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
