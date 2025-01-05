defmodule ExCop.Cops.Naming.AvoidOneLetterVariablesTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Naming.AvoidOneLetterVariables

  @tag parse: "naming/avoid_one_letter_variables/underscore_variable"
  test "ignores underscore variables", %{forms: forms, comments: comments} do
    AvoidOneLetterVariables.apply({forms, comments}, [])
  end
end
