defmodule ExCopTest do
  use ExUnit.Case, async: true

  setup context do
    bad =
      ["test", "fixtures", "#{context[:fixture]}_bad.ex"]
      |> Path.join()
      |> File.read!()

    good =
      ["test", "fixtures", "#{context[:fixture]}.ex"]
      |> Path.join()
      |> File.read!()

    %{bad: bad, good: good}
  end

  @tag fixture: "linting/favor_pipeline_operator"
  test "transforms nested function calls to pipelines", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture: "linting/avoid_needless_pipelines"
  test "removes needless pipelines", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture: "linting/no_else_with_unless"
  test "corrects unless/else to if/else", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture: "linting/no_nil_else"
  test "removes nil else clauses", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture: "linting/true_in_cond"
  test "replaces symbols with true in cond", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture: "linting/use_string_concatenation_when_pattern_matching_binaries"
  test "replaces bitstrings with <> when pattern_matching binaries", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture: "modules/module_layout"
  test "corrects the order of module references", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end
end
