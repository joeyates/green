defmodule Green.Rules.Modules.UseModulePseudoVariableTest do
  use Green.TestCase, async: true

  alias Green.Rules.Modules.UseModulePseudoVariable

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

  describe "except configuration" do
    test "skips transformation when entire file is in except list" do
      code = """
      defmodule Example do
        alias Example.SubModule
        def foo, do: Example.SubModule.bar()
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        UseModulePseudoVariable.apply({forms, comments},
          green: [use_module_pseudo_variable: [except: ["test/example.exs"]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when file is in except list
      assert output == code
    end

    test "skips transformation for specific line when in except list" do
      code = """
      defmodule Example do
        def foo, do: Example.bar()
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        UseModulePseudoVariable.apply({forms, comments},
          green: [use_module_pseudo_variable: [except: [{"test/example.exs", 2}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when line is in except list
      assert output == code
    end

    test "transforms lines not in except list" do
      code = """
      defmodule Example do
        def foo, do: Example.bar()
        def baz, do: Example.qux()
      end
      """

      expected = """
      defmodule Example do
        def foo, do: Example.bar()
        def baz, do: __MODULE__.qux()
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        UseModulePseudoVariable.apply({forms, comments},
          green: [use_module_pseudo_variable: [except: [{"test/example.exs", 2}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should only transform line 3, not line 2
      assert output == expected
    end
  end
end
