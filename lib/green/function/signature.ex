defmodule Green.Function.Signature do
  @moduledoc """
  This module defines a struct that represents a function signature.

  N.B. We store names and modules as Strings, because, otherwise we would have to
  convert Strings to possibly non-existent Atoms when splitting the module(s) from
  the function name.
  """

  @enforce_keys [:name, :arity]
  defstruct [:name, :arity, modules: []]

  def new(modules \\ [], name, arity) do
    %__MODULE__{name: name, arity: arity, modules: modules}
  end
end
