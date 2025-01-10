defmodule ExCop.Cops.Linting.UseStringConcatenationWhenMatchingBinariesTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Linting.UseStringConcatenationWhenMatchingBinaries

  @tag parse: "linting/use_string_concatenation_when_matching_binaries/single_bytes_entry_bad"
  @tag fixture_pair: "linting/use_string_concatenation_when_matching_binaries/single_bytes_entry"
  test "extracts bytes match from bitstrings with a single entry", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = UseStringConcatenationWhenMatchingBinaries.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag parse: "linting/use_string_concatenation_when_matching_binaries/single_binary_entry_bad"
  @tag fixture_pair: "linting/use_string_concatenation_when_matching_binaries/single_binary_entry"
  test "extracts binary match from bitstrings with a single entry", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = UseStringConcatenationWhenMatchingBinaries.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag parse: "linting/use_string_concatenation_when_matching_binaries/single_string_entry_bad"
  @tag fixture_pair: "linting/use_string_concatenation_when_matching_binaries/single_string_entry"
  test "extracts string from bitstrings with a single entry", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = UseStringConcatenationWhenMatchingBinaries.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag parse: "linting/use_string_concatenation_when_matching_binaries/mixed_entries_bad"
  @tag fixture_pair: "linting/use_string_concatenation_when_matching_binaries/mixed_entries"
  test "extracts strings and binaries, grouping remaining entries", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = UseStringConcatenationWhenMatchingBinaries.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end
end
