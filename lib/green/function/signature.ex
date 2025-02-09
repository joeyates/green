defmodule Green.Function.Signature do
  @moduledoc """
  This module defines a struct that represents a function signature.
  """

  @enforce_keys [:name, :arity]
  defstruct [:name, :arity, modules: []]

  def new(modules \\ [], name, arity) do
    %__MODULE__{name: name, arity: arity, modules: modules}
  end
end
