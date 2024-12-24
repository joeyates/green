defmodule ExCop.Cops.Modules.UseModulePseudoVariableTest do
  use ExCop.TestCase, async: true

  import ExCop.Cops.Modules.UseModulePseudoVariable

  @tag parse: "modules/nested_modules"
  test "handles nested modules", %{forms: forms, comments: comments} do
    apply({forms, comments})
  end
end
