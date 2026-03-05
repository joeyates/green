defmodule Green.Rules.Exceptions.NoTrailingPunctuationInExceptionMessagesTest do
  use Green.TestCase, async: true

  import ExUnit.CaptureIO

  alias Green.Rules.Exceptions.NoTrailingPunctuationInExceptionMessages

  describe "except configuration" do
    test "skips warnings when entire file is in except list" do
      code = """
      defmodule Example do
        def foo do
          raise ArgumentError, "something went wrong."
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          NoTrailingPunctuationInExceptionMessages.apply({forms, comments},
            green: [no_trailing_punctuation_in_exception_messages: [except: ["test/example.exs"]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "skips warning for specific line when in except list" do
      code = """
      defmodule Example do
        def foo do
          raise ArgumentError, "something went wrong."
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          NoTrailingPunctuationInExceptionMessages.apply({forms, comments},
            green: [
              no_trailing_punctuation_in_exception_messages: [except: [{"test/example.exs", 3}]]
            ],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "warns for lines not in except list" do
      code = """
      defmodule Example do
        def foo do
          raise ArgumentError, "something went wrong."
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          NoTrailingPunctuationInExceptionMessages.apply({forms, comments},
            green: [
              no_trailing_punctuation_in_exception_messages: [except: [{"test/example.exs", 999}]]
            ],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "exception message should not have trailing punctuation"
    end
  end
end
