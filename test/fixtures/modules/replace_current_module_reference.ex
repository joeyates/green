defmodule MyModule do
  defstruct [:foo]

  def frobnicate(%__MODULE__{foo: foo}) do
    foo
  end
end
