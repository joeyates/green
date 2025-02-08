defmodule Green.Rules.Structs.RemoveNilFromStructDefinitionTest do
  use Green.TestCase, async: true

  alias Green.Rules.Structs.RemoveNilFromStructDefinition

  @tag example: "structs/skip_nil_in_struct_definition/from_mixed_bad"
  @tag fixture_pair: "structs/skip_nil_in_struct_definition/from_mixed"
  test "updates mixed defstructs", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = RemoveNilFromStructDefinition.apply({forms, comments}, [])
    output = default_format({forms, comments})

    assert output == good
  end

  @tag example: "structs/skip_nil_in_struct_definition/keywords_bad"
  @tag fixture_pair: "structs/skip_nil_in_struct_definition/keywords"
  test "updates all-keyword defstructs", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = RemoveNilFromStructDefinition.apply({forms, comments}, [])
    output = default_format({forms, comments})

    assert output == good
  end
end
