defmodule AvoidCaps do
  def capital_in_atom() do
    :someAtom
  end

  @anAttribute 1

  def capital_in_attribute_name() do
    @anAttribute
  end

  def capital_in_Function_name() do
    nil
  end

  def capital_in_variable() do
    myVariable = 1
    myVariable
  end

  def capital_in_module_struct(%__MODULE__{foo: foo}) do
    foo
  end
end
