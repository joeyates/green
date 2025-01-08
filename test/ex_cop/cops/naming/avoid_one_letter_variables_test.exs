defmodule ExCop.Cops.Naming.AvoidOneLetterVariablesTest do
  use ExCop.TestCase, async: true

  import ExUnit.CaptureIO

  alias ExCop.Cops.Naming.AvoidOneLetterVariables

  @tag parse: "naming/avoid_one_letter_variables/underscore_variable"
  test "ignores underscore variables", %{forms: forms, comments: comments} do
    output =
      capture_io(:stderr, fn ->
        AvoidOneLetterVariables.apply({forms, comments}, [])
      end)

    assert output == ""
  end
end
