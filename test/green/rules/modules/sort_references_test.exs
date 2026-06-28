defmodule Green.Rules.Modules.SortReferencesTest do
  use Green.TestCase, async: true

  alias Green.Rules.Modules.SortReferences

  @tag bad: "modules/sort_references/script_modules_bad"
  @tag good: "modules/sort_references/script_modules"
  test "handles nested modules", %{bad_forms: bad_forms, bad_comments: bad_comments, good: good} do
    {forms, comments} = SortReferences.apply({bad_forms, bad_comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  describe "except configuration" do
    test "skips transformation when entire file is in except list" do
      code = """
      defmodule Example do
        import B
        alias A
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        SortReferences.apply({forms, comments},
          green: [sort_module_references: [except: ["test/example.exs"]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not sort when file is in except list
      assert output == code
    end

    test "skips transformation for specific line when in except list" do
      code = """
      defmodule Example do
        import B
        alias A
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        SortReferences.apply({forms, comments},
          green: [sort_module_references: [except: [{"test/example.exs", 1}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not sort when defmodule line is in except list
      assert output == code
    end
  end
end
