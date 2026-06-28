defmodule Green.Rules.Naming.AvoidCapsTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Naming.AvoidCaps

  @tag good: "naming/avoid_caps/elixir_special_forms"
  test "ignores Elixir special forms", %{good_forms: good_forms, good_comments: good_comments} do
    output =
      capture_io(:stderr, fn ->
        AvoidCaps.apply({good_forms, good_comments}, [])
      end)

    assert output == ""
  end

  @tag bad: "naming/avoid_caps/file_level_config"
  test "supports file-level configuration of atoms to accept", %{
    bad_forms: bad_forms,
    bad_comments: bad_comments
  } do
    output =
      capture_io(:stderr, fn ->
        AvoidCaps.apply({bad_forms, bad_comments}, [])
      end)

    refute output =~ ~r/\bMyAtom\b/
    refute output =~ ~r/\bOtherAtom\b/
  end

  @tag bad: "naming/avoid_caps/file_level_config"
  test "warns about other atoms when there is file-level configuration of atoms to accept", %{
    bad_forms: bad_forms,
    bad_comments: bad_comments
  } do
    output =
      capture_io(:stderr, fn ->
        AvoidCaps.apply({bad_forms, bad_comments}, [])
      end)

    assert output =~ "BadAtom"
  end

  describe "except configuration" do
    test "skips warnings when entire file is in except list" do
      code = """
      defmodule Example do
        def fooBar, do: :ok
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          AvoidCaps.apply({forms, comments},
            green: [avoid_caps: [except: ["test/example.exs"]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "skips warning for specific line when in except list" do
      code = """
      defmodule Example do
        def fooBar, do: :ok
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          AvoidCaps.apply({forms, comments},
            green: [avoid_caps: [except: [{"test/example.exs", 2}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "warns for lines not in except list" do
      code = """
      defmodule Example do
        def fooBar, do: :ok
        def bazQux, do: :ok
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          AvoidCaps.apply({forms, comments},
            green: [avoid_caps: [except: [{"test/example.exs", 2}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "capital letter found in function name"
      assert output =~ "3 |"
      refute output =~ "2 |"
    end
  end
end
