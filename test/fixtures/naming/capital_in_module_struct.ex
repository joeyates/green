defmodule CapitalInModuleStruct do
  def capital_in_module_struct(%__MODULE__{foo: foo}) do
    foo
  end
end
