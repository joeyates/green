defmodule Green.Rules.Naming.PredicateFunctionsTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Naming.PredicateFunctions

  @def_with_is_example """
  defmodule Example do
    def is_valid(x), do: true
  end
  """

  @defmacro_with_question_mark_example """
  defmodule Example do
    defmacro valid?(x), do: true
  end
  """

  test "warns when predicate function does not have `?` suffix" do
    {forms, comments} = parse_code(@def_with_is_example)

    output =
      capture_io(:stderr, fn ->
        PredicateFunctions.apply({forms, comments},
          green: [predicate_functions: [enabled: true]],
          file: Path.expand("test/example.exs")
        )
      end)

    assert output =~ "predicate function should have `?` suffix"
    assert output =~ "2 |"
  end

  test "warns when a guard-style macro does not have `is_` prefix" do
    {forms, comments} = parse_code(@defmacro_with_question_mark_example)

    output =
      capture_io(:stderr, fn ->
        PredicateFunctions.apply({forms, comments},
          green: [predicate_functions: [enabled: true]],
          file: Path.expand("test/example.exs")
        )
      end)

    assert output =~ "guard-style macros should not have `?` suffix, use `is_` prefix instead"
    assert output =~ "2 |"
  end

  test "skips checks when macro name is not an atom" do
    code = """
    defmodule Example do
      defmacro unquote(foo)(x), do: true
    end
    """

    {forms, comments} = parse_code(code)

    output =
      capture_io(:stderr, fn ->
        PredicateFunctions.apply({forms, comments},
          green: [predicate_functions: [enabled: true]],
          file: Path.expand("test/example.exs")
        )
      end)

    assert output == ""
  end

  describe "except configuration" do
    test "skips warning when entire file is in except list" do
      {forms, comments} = parse_code(@def_with_is_example)

      output =
        capture_io(:stderr, fn ->
          PredicateFunctions.apply({forms, comments},
            green: [predicate_functions: [except: ["test/example.exs"]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "skips warning for specific line when in except list" do
      {forms, comments} = parse_code(@def_with_is_example)

      output =
        capture_io(:stderr, fn ->
          PredicateFunctions.apply({forms, comments},
            green: [predicate_functions: [except: [{"test/example.exs", 2}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "warns for lines not in except list" do
      code = """
      defmodule Example do
        def is_valid(x), do: true
        def is_active(y), do: false
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          PredicateFunctions.apply({forms, comments},
            green: [predicate_functions: [except: [{"test/example.exs", 2}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "predicate function should have `?` suffix"
      assert output =~ "3 |"
    end
  end
end
