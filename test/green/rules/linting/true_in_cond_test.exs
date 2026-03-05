defmodule Green.Rules.Linting.TrueInCondTest do
  use Green.TestCase, async: false

  import ExUnit.CaptureIO

  alias Green.Rules.Linting.TrueInCond

  describe "warnings" do
    test "warns when final clause uses atom instead of true" do
      code = """
      defmodule TrueInCond do
        def classify(param) do
          cond do
            is_list(param) ->
              :list

            :other ->
              :other
          end
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          TrueInCond.apply({forms, comments}, [])
        end)

      assert output =~ "cond"
      assert output =~ "true"
    end

    test "does not warn when final clause uses true" do
      code = """
      defmodule TrueInCond do
        def classify(param) do
          cond do
            is_list(param) ->
              :list

            true ->
              :other
          end
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          TrueInCond.apply({forms, comments}, [])
        end)

      assert output == ""
    end
  end

  describe "except configuration" do
    test "skips warnings when entire file is in except list" do
      code = """
      defmodule TrueInCond do
        def classify(param) do
          cond do
            is_list(param) ->
              :list

            :other ->
              :other
          end
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          TrueInCond.apply({forms, comments},
            green: [true_in_cond: [except: ["test/example.exs"]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "skips warning for specific line when in except list" do
      code = """
      defmodule TrueInCond do
        def classify(param) do
          cond do
            is_list(param) ->
              :list

            :other ->
              :other
          end
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          TrueInCond.apply({forms, comments},
            green: [true_in_cond: [except: [{"test/example.exs", 3}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output == ""
    end

    test "warns for lines not in except list" do
      code = """
      defmodule TrueInCond do
        def classify(param) do
          cond do
            is_list(param) ->
              :list

            :other ->
              :other
          end
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          TrueInCond.apply({forms, comments},
            green: [true_in_cond: [except: [{"test/example.exs", 999}]]],
            file: Path.expand("test/example.exs")
          )
        end)

      assert output =~ "cond"
      assert output =~ "true"
    end
  end

  describe "enabled configuration" do
    test "does not warn when rule is disabled" do
      code = """
      defmodule TrueInCond do
        def classify(param) do
          cond do
            is_list(param) ->
              :list

            :other ->
              :other
          end
        end
      end
      """

      {forms, comments} = parse_code(code)

      output =
        capture_io(:stderr, fn ->
          TrueInCond.apply({forms, comments},
            green: [true_in_cond: [enabled: false]]
          )
        end)

      assert output == ""
    end
  end
end
