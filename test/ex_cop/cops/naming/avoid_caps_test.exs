defmodule ExCop.Cops.Naming.AvoidCapsTest do
  use ExCop.TestCase, async: true

  import ExUnit.CaptureIO

  alias ExCop.Cops.Naming.AvoidCaps

  @tag parse: "naming/avoid_caps/elixir_variables"
  test "ignores underscore variables", %{forms: forms, comments: comments} do
    output =
      capture_io(:stderr, fn ->
        AvoidCaps.apply({forms, comments}, [])
      end)

    assert output == ""
  end
end
