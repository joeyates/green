defmodule ExCop.Cops.Naming.AvoidOneLetterVariablesTest do
  use ExCop.TestCase, async: true

  import ExCop.Cops.Naming.AvoidOneLetterVariables

  @tag parse: "naming/underscore_variable"
  test "ignores underscore variables", %{forms: forms, comments: comments} do
    apply({forms, comments})
  end
end
