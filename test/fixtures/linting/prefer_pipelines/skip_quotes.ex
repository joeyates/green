defmodule SkipQuotes do
  def foo() do
    quote do
      String.split(String.downcase("HELLO"), "l")
    end
  end
end
