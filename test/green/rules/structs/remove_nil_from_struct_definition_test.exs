defmodule Green.Rules.Structs.RemoveNilFromStructDefinitionTest do
  use Green.TestCase, async: true

  alias Green.Rules.Structs.RemoveNilFromStructDefinition

  @tag bad: "structs/skip_nil_in_struct_definition/from_mixed_bad"
  @tag good: "structs/skip_nil_in_struct_definition/from_mixed"
  test "updates mixed defstructs", %{
    bad_forms: bad_forms,
    bad_comments: bad_comments,
    good: good
  } do
    {forms, comments} = RemoveNilFromStructDefinition.apply({bad_forms, bad_comments}, [])
    output = default_format({forms, comments})

    assert output == good
  end

  @tag bad: "structs/skip_nil_in_struct_definition/keywords_bad"
  @tag good: "structs/skip_nil_in_struct_definition/keywords"
  test "updates all-keyword defstructs", %{
    bad_forms: bad_forms,
    bad_comments: bad_comments,
    good: good
  } do
    {forms, comments} = RemoveNilFromStructDefinition.apply({bad_forms, bad_comments}, [])
    output = default_format({forms, comments})

    assert output == good
  end

  describe "except configuration" do
    test "skips transformation when entire file is in except list" do
      code = """
      defmodule Example do
        defstruct foo: nil, bar: 1
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        RemoveNilFromStructDefinition.apply({forms, comments},
          green: [remove_nil_from_struct_definition: [except: ["test/example.exs"]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when file is in except list
      assert output == code
    end

    test "skips transformation for specific line when in except list" do
      code = """
      defmodule Example do
        defstruct foo: nil, bar: 1
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        RemoveNilFromStructDefinition.apply({forms, comments},
          green: [remove_nil_from_struct_definition: [except: [{"test/example.exs", 2}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when line is in except list
      assert output == code
    end

    test "transforms lines not in except list" do
      code = """
      defmodule Example do
        defstruct foo: nil, bar: 1
      end
      """

      expected = """
      defmodule Example do
        defstruct [:foo, bar: 1]
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        RemoveNilFromStructDefinition.apply({forms, comments},
          green: [remove_nil_from_struct_definition: [except: [{"test/example.exs", 999}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should transform because line 2 is not in except list
      assert output == expected
    end
  end
end
