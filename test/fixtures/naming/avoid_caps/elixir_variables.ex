defmodule ElixirVariables do
  def foo() do
    [
      __CALLER__,
      __DIR__,
      __ENV__,
      __MODULE__,
      __STACKTRACE__,
      :DOWN,
      :EXIT,
      :__FILE__
    ]
  end
end
