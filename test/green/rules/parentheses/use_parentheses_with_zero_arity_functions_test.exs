defmodule Green.Rules.Parentheses.UseParenthesesWithZeroArityFunctionsTest do
  use Green.TestCase, async: true

  alias Green.Rules.Parentheses.UseParenthesesWithZeroArityFunctions

  @tag bad: "parentheses/use_parentheses_with_zero_arity_functions_bad"
  @tag good: "parentheses/use_parentheses_with_zero_arity_functions"
  test "adds parentheses to zero-arity function definitions", %{
    bad_forms: bad_forms,
    bad_comments: bad_comments,
    good: good
  } do
    {forms, comments} = UseParenthesesWithZeroArityFunctions.apply({bad_forms, bad_comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag bad: "parentheses/use_parentheses_with_zero_arity_functions_bad"
  test "supports configuration to disable the rule", %{
    bad_forms: bad_forms,
    bad_comments: bad_comments,
    bad: unchanged
  } do
    {forms, comments} =
      UseParenthesesWithZeroArityFunctions.apply({bad_forms, bad_comments},
        green: [use_parentheses_with_zero_arity_functions: [enabled: false]]
      )

    output = default_format({forms, comments})
    assert output == unchanged
  end

  describe "except configuration" do
    test "skips transformation when entire file is in except list" do
      code = """
      defmodule Example do
        def foo, do: :ok
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        UseParenthesesWithZeroArityFunctions.apply({forms, comments},
          green: [use_parentheses_with_zero_arity_functions: [except: ["test/example.exs"]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when file is in except list
      assert output == code
    end

    test "skips transformation for specific line when in except list" do
      code = """
      defmodule Example do
        def foo, do: :ok
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        UseParenthesesWithZeroArityFunctions.apply({forms, comments},
          green: [use_parentheses_with_zero_arity_functions: [except: [{"test/example.exs", 2}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when line is in except list
      assert output == code
    end

    test "transforms lines not in except list" do
      code = """
      defmodule Example do
        def foo, do: :ok
        def bar, do: :nok
      end
      """

      expected = """
      defmodule Example do
        def foo, do: :ok
        def bar(), do: :nok
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        UseParenthesesWithZeroArityFunctions.apply({forms, comments},
          green: [use_parentheses_with_zero_arity_functions: [except: [{"test/example.exs", 2}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should only transform line 3, not line 2
      assert output == expected
    end
  end
end
