defmodule ExCop.Function.Signature do
  @moduledoc """
  This module defines a struct that represents a function signature.

  N.B. We store names and modules as Strings, because, otherwise we would have to
  convert Strings to possibly non-existent Atoms.
  """

  @enforce_keys [:name, :arity]
  defstruct [:name, :arity, modules: []]

  def new(modules \\ [], name, arity) do
    %__MODULE__{name: to_string(name), arity: arity, modules: Enum.map(modules, &stringify/1)}
  end

  defp stringify(module) when is_binary(module), do: module

  defp stringify(module) when is_atom(module), do: Atom.to_string(module)

  defp stringify({:__MODULE__, _ctx, nil}), do: "__MODULE__"
end
