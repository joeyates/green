defmodule Green.Rules.Naming.UpperCamelCaseForModulesTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Naming.UpperCamelCaseForModules

  describe "except configuration" do
    test "skips warning when entire file is in except list" do
      code = """
      defmodule :appStack do
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          UpperCamelCaseForModules.apply({forms, comments},
            green: [upper_camel_case_for_modules: [except: ["test/example.exs"]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "skips warning for specific line when in except list" do
      code = """
      defmodule :appStack do
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          UpperCamelCaseForModules.apply({forms, comments},
            green: [upper_camel_case_for_modules: [except: [{"test/example.exs", 1}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "warns for lines not in except list" do
      code = """
      defmodule :appStack do
      end

      defmodule :badName do
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          UpperCamelCaseForModules.apply({forms, comments},
            green: [upper_camel_case_for_modules: [except: [{"test/example.exs", 1}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "found badly formed module name"
      assert output =~ "4 |"
    end
  end
end
