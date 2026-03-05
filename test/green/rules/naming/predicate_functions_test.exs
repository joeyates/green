defmodule Green.Rules.Naming.PredicateFunctionsTest do
  use Green.TestCase, async: true

  import ExUnit.CaptureIO

  alias Green.Rules.Naming.PredicateFunctions

  describe "except configuration" do
    test "skips warning when entire file is in except list" do
      code = """
      defmodule Example do
        def is_valid(x), do: true
      end
      """

      {forms, comments} = parse_code(code)

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
      code = """
      defmodule Example do
        def is_valid(x), do: true
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
