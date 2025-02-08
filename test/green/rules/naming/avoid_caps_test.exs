defmodule Green.Rules.Naming.AvoidCapsTest do
  use Green.TestCase, async: true

  import ExUnit.CaptureIO

  alias Green.Rules.Naming.AvoidCaps

  @tag example: "naming/avoid_caps/elixir_variables"
  test "ignores underscore variables", %{forms: forms, comments: comments} do
    output =
      capture_io(:stderr, fn ->
        AvoidCaps.apply({forms, comments}, [])
      end)

    assert output == ""
  end
end
