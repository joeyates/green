defmodule KeywordArguments do
  def foo() do
    baz(bar(a: 1, b: 2))
  end
end
