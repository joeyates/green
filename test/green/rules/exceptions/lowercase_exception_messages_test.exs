defmodule Green.Rules.Exceptions.LowercaseExceptionMessagesTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Exceptions.LowercaseExceptionMessages

  describe "except configuration" do
    test "skips warnings when entire file is in except list" do
      code = """
      defmodule Example do
        def foo do
          raise ArgumentError, "Something went wrong"
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          LowercaseExceptionMessages.apply({forms, comments},
            green: [lowercase_exception_messages: [except: ["test/example.exs"]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "skips warning for specific line when in except list" do
      code = """
      defmodule Example do
        def foo do
          raise ArgumentError, "Something went wrong"
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          LowercaseExceptionMessages.apply({forms, comments},
            green: [lowercase_exception_messages: [except: [{"test/example.exs", 3}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "warns for lines not in except list" do
      code = """
      defmodule Example do
        def foo do
          raise ArgumentError, "Something went wrong"
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          LowercaseExceptionMessages.apply({forms, comments},
            green: [lowercase_exception_messages: [except: [{"test/example.exs", 999}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "exception message should be lowercase"
    end
  end
end
