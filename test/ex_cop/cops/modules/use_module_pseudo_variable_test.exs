defmodule ExCop.Cops.Modules.UseModulePseudoVariableTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Modules.UseModulePseudoVariable

  @tag example: "modules/use_module_pseudo_variable/nested_modules"
  test "handles nested modules", %{forms: forms, comments: comments} do
    UseModulePseudoVariable.apply({forms, comments}, [])
  end

  @tag example: "modules/use_module_pseudo_variable/ignore_in_quote"
  test "ignores references to the current module in `quote`", %{
    forms: forms,
    comments: comments,
    example: example
  } do
    {forms, comments} = UseModulePseudoVariable.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end

  @tag example: "modules/use_module_pseudo_variable/ignore_in_defimpl"
  test "ignores references to the current module in `defimpl`", %{
    forms: forms,
    comments: comments,
    example: example
  } do
    {forms, comments} = UseModulePseudoVariable.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end
end
