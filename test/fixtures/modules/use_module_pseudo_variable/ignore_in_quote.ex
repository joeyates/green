defmodule IgnoreInQuote do
  def foo() do
    quote do
      import IgnoreInQuote
    end
  end
end
