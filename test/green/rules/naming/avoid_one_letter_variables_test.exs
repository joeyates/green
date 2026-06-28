defmodule Green.Rules.Naming.AvoidOneLetterVariablesTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Naming.AvoidOneLetterVariables

  @tag good: "naming/avoid_one_letter_variables/underscore_variable"
  test "ignores underscore variables", %{good_forms: good_forms, good_comments: good_comments} do
    output =
      capture_io(:stderr, fn ->
        AvoidOneLetterVariables.apply({good_forms, good_comments}, [])
      end)

    assert output == ""
  end

  @tag good: "naming/avoid_one_letter_variables/types"
  test "ignores variables in types", %{good_forms: good_forms, good_comments: good_comments} do
    output =
      capture_io(:stderr, fn ->
        AvoidOneLetterVariables.apply({good_forms, good_comments}, [])
      end)

    assert output == ""
  end

  describe "except configuration" do
    test "skips warning when entire file is in except list" do
      code = """
      defmodule Example do
        def foo(x), do: x
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          AvoidOneLetterVariables.apply({forms, comments},
            green: [avoid_one_letter_variables: [except: ["test/example.exs"]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "skips warning for specific line when in except list" do
      code = """
      defmodule Example do
        def foo(x), do: x
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          AvoidOneLetterVariables.apply({forms, comments},
            green: [avoid_one_letter_variables: [except: [{"test/example.exs", 2}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "warns for lines not in except list" do
      code = """
      defmodule Example do
        def foo(x), do: x
        def bar(y), do: y
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          AvoidOneLetterVariables.apply({forms, comments},
            green: [avoid_one_letter_variables: [except: [{"test/example.exs", 2}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "one-letter variable name found"
      assert output =~ "3 | y"
    end
  end
end
