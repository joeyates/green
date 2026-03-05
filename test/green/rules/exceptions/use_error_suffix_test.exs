defmodule Green.Rules.Exceptions.UseErrorSuffixTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Exceptions.UseErrorSuffix

  @tag example: "exceptions/use_error_suffix/namespaced_error"
  test "handles namespaced error modules", %{forms: forms, comments: comments, example: example} do
    {forms, comments} = UseErrorSuffix.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end

  describe "except configuration" do
    test "skips warnings when entire file is in except list" do
      code = """
      defmodule MyBad do
        defexception message: "some error"
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          UseErrorSuffix.apply({forms, comments},
            green: [use_error_suffix: [except: ["test/example.exs"]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "skips warning for specific line when in except list" do
      code = """
      defmodule MyBad do
        defexception message: "some error"
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          UseErrorSuffix.apply({forms, comments},
            green: [use_error_suffix: [except: [{"test/example.exs", 1}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "warns for lines not in except list" do
      code = """
      defmodule MyBad do
        defexception message: "some error"
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          UseErrorSuffix.apply({forms, comments},
            green: [use_error_suffix: [except: [{"test/example.exs", 999}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "MyBad"
      assert output =~ "should have a suffix of `Error`"
    end
  end
end
