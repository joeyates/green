defmodule MyModule do
  defstruct [:foo]

  def frobnicate(%MyModule{foo: foo}) do
    foo
  end
end
