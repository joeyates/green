defmodule Green.Rules.Naming.AvoidCapsTest do
  use Green.TestCase, async: true

  import ExUnit.CaptureIO

  alias Green.Rules.Naming.AvoidCaps

  @tag example: "naming/avoid_caps/elixir_special_forms"
  test "ignores Elixir special forms", %{forms: forms, comments: comments} do
    output =
      capture_io(:stderr, fn ->
        AvoidCaps.apply({forms, comments}, [])
      end)

    assert output == ""
  end

  @tag example: "naming/avoid_caps/file_level_config"
  test "supports file-level configuration of atoms to accept", %{
    forms: forms,
    comments: comments
  } do
    output =
      capture_io(:stderr, fn ->
        AvoidCaps.apply({forms, comments}, [])
      end)

    refute output =~ ~r/\bMyAtom\b/
    refute output =~ ~r/\bOtherAtom\b/
  end

  @tag example: "naming/avoid_caps/file_level_config"
  test "warns about other atoms when there is file-level configuration of atoms to accept", %{
    forms: forms,
    comments: comments
  } do
    output =
      capture_io(:stderr, fn ->
        AvoidCaps.apply({forms, comments}, [])
      end)

    assert output =~ "BadAtom"
  end
end
