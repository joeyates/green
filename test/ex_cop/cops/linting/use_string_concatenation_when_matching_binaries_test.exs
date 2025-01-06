defmodule ExCop.Cops.Linting.UseStringConcatenationWhenMatchingBinariesTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Linting.UseStringConcatenationWhenMatchingBinaries

  @tag parse: "linting/use_string_concatenation_when_matching_binaries/single_entry"
  @tag example: "linting/use_string_concatenation_when_matching_binaries/single_entry"
  test "ignores binaries with a single entry", %{
    forms: forms,
    comments: comments,
    example: example
  } do
    {forms, comments} = UseStringConcatenationWhenMatchingBinaries.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end

  @tag parse: "linting/use_string_concatenation_when_matching_binaries/last_entry_not_bytes"
  @tag example: "linting/use_string_concatenation_when_matching_binaries/last_entry_not_bytes"
  test "ignores binaries where the last entry cannot be extracted as a string", %{
    forms: forms,
    comments: comments,
    example: example
  } do
    {forms, comments} = UseStringConcatenationWhenMatchingBinaries.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end
end
