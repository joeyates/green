defmodule Green.Rules.Linting.BooleanOperatorsTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Linting.BooleanOperators

  test "warns when using && with boolean literals" do
    code = """
    true && false
    """

    {forms, comments} = parse_code(code)

    output =
      capture_io(:stderr, fn ->
        BooleanOperators.apply({forms, comments},
          file: Path.expand("test/example.exs")
        )
      end)

    assert output =~ "use `and` instead of `&&` for boolean checks"
  end

  test "ignores !!" do
    code = """
    !!true
    """

    {forms, comments} = parse_code(code)

    output =
      capture_io(:stderr, fn ->
        BooleanOperators.apply({forms, comments},
          file: Path.expand("test/example.exs")
        )
      end)

    assert output == ""
  end

  describe "warnings include filename" do
    test "includes filename in warning for && operator" do
      code = """
      true && false
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          BooleanOperators.apply({forms, comments},
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "test/example.exs"
      assert output =~ "use `and` instead of `&&` for boolean checks"
    end

    test "includes filename in warning for ! operator" do
      code = """
      !true
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          BooleanOperators.apply({forms, comments},
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "test/example.exs"
      assert output =~ "use `not` instead of `!` for boolean checks"
    end
  end
end
