defmodule ExCop.Cops.Modules.UseModulePseudoVariableTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Modules.UseModulePseudoVariable

  @tag parse: "modules/nested_modules"
  test "handles nested modules", %{forms: forms, comments: comments} do
    UseModulePseudoVariable.apply({forms, comments}, [])
  end
end
