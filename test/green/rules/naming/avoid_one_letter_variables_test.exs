defmodule Green.Rules.Naming.AvoidOneLetterVariablesTest do
  use Green.TestCase, async: true

  import ExUnit.CaptureIO

  alias Green.Rules.Naming.AvoidOneLetterVariables

  @tag example: "naming/avoid_one_letter_variables/underscore_variable"
  test "ignores underscore variables", %{forms: forms, comments: comments} do
    output =
      capture_io(:stderr, fn ->
        AvoidOneLetterVariables.apply({forms, comments}, [])
      end)

    assert output == ""
  end
end
