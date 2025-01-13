defmodule ExCop.Cops.Structs.RemoveNilFromStructDefinitionTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Structs.RemoveNilFromStructDefinition

  @tag example: "structs/skip_nil_in_struct_definition/from_mixed_bad"
  @tag fixture_pair: "structs/skip_nil_in_struct_definition/from_mixed"
  test "removes `nil` defaults from struct definitions, starting from a mixed list", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = RemoveNilFromStructDefinition.apply({forms, comments}, [])
    output = default_format({forms, comments})

    assert output == good
  end
end
