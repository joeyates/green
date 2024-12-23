defmodule ExCopTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  def read_fixture(filename) do
    ["test", "fixtures", filename]
    |> Path.join()
    |> File.read!()
  end

  setup context do
    case context do
      %{fixture_pair: fixture} ->
        bad = read_fixture("#{fixture}_bad.ex")
        good = read_fixture("#{fixture}.ex")
        %{bad: bad, good: good}

      %{example: filename} ->
        example = read_fixture("#{filename}.ex")
        %{example: example}

      _any ->
        :ok
    end
  end

  @tag fixture_pair: "linting/favor_pipeline_operator"
  test "transforms nested function calls to pipelines", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture_pair: "linting/avoid_needless_pipelines"
  test "removes needless pipelines", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture_pair: "linting/no_else_with_unless"
  test "corrects unless/else to if/else", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture_pair: "linting/no_nil_else"
  test "removes nil else clauses", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture_pair: "linting/true_in_cond"
  test "replaces symbols with true in cond", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag fixture_pair: "linting/use_string_concatenation_when_pattern_matching_binaries"
  test "replaces bitstrings with <> when pattern_matching binaries", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end

  @tag example: "naming/capital_in_atom"
  test "warns when capital letters are used in atoms", %{example: example} do
    output = capture_io(:stderr, fn -> ExCop.format_string(example) end)

    assert String.starts_with?(
             output,
             """
             \e[33mwarning:\e[0m capital letter found in atom (use snake_case for atoms)
             3 | :someAtom
             """
           )
  end

  @tag example: "naming/capital_in_function_name"
  test "warns when capital letters are used in function names", %{example: example} do
    output = capture_io(:stderr, fn -> ExCop.format_string(example) end)

    assert String.starts_with?(
             output,
             """
             \e[33mwarning:\e[0m capital letter found in function name (use snake_case for function names)
             2 | capital_in_Function_name
             """
           )
  end

  @tag example: "naming/capital_in_variable_name"
  test "warns when capital letters are used in variable names", %{example: example} do
    output = capture_io(:stderr, fn -> ExCop.format_string(example) end)

    assert String.starts_with?(
             output,
             """
             \e[33mwarning:\e[0m capital letter found in variable name (use snake_case for variable names)
             3 | _myVariable
             """
           )
  end

  @tag example: "naming/capital_in_attribute_name"
  test "warns when capital letters are used in attribute names", %{example: example} do
    output = capture_io(:stderr, fn -> ExCop.format_string(example) end)

    assert String.starts_with?(
             output,
             """
             \e[33mwarning:\e[0m capital letter found in attribute name (use snake_case for attribute names)
             2 | @anAttribute
             """
           )
  end

  @tag fixture_pair: "modules/module_layout"
  test "corrects the order of module references", %{bad: bad, good: good} do
    formatted = ExCop.format_string(bad)

    assert formatted == good
  end
end
