defmodule ExCop.Function.Signature do
  @moduledoc """
  This module defines a struct that represents a function signature.

  N.B. We store names and modules as Strings, because, otherwise we would have to
  convert Strings to possibly non-existent Atoms.
  """

  @enforce_keys [:name, :arity]
  defstruct [:name, :arity, modules: []]

  def new(modules \\ [], name, arity) do
    %__MODULE__{name: to_string(name), arity: arity, modules: Enum.map(modules, &to_string/1)}
  end
end
