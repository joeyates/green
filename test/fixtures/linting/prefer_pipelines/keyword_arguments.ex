defmodule KeywordArguments do
  def foo() do
    [a: 1, b: 2] |> bar() |> baz()
  end
end
