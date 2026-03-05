defmodule Green.Rules.Linting.NoAnonymousFunctionsInPipelinesTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Linting.NoAnonymousFunctionsInPipelines

  describe "warnings include filename" do
    test "includes filename in warning for anonymous function in pipeline" do
      code = """
      [1, 2, 3]
      |> (fn x -> x * 2 end).()
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          NoAnonymousFunctionsInPipelines.apply({forms, comments},
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "test/example.exs"
      assert output =~ "anonymous function found in pipeline"
    end
  end
end
