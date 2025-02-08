defmodule Green.Rules.Modules.SortReferencesTest do
  use Green.TestCase, async: true

  alias Green.Rules.Modules.SortReferences

  @tag example: "modules/sort_references/script_modules_bad"
  @tag fixture_pair: "modules/sort_references/script_modules"
  test "handles nested modules", %{forms: forms, comments: comments, good: good} do
    {forms, comments} = SortReferences.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end
end
