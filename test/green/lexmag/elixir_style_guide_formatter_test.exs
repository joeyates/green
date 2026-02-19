defmodule Green.Lexmag.ElixirStyleGuideFormatterTest do
  use Green.TestCase, async: true

  import Green.Lexmag.ElixirStyleGuideFormatter
  import ExUnit.CaptureIO

  describe "format/1" do
    @tag fixture_pair: "linting/favor_pipeline_operator"
    test "transforms nested function calls to pipelines", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag fixture_pair: "linting/avoid_needless_pipelines"
    test "removes needless pipelines", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag fixture_pair: "linting/incomplete_pipeline"
    test "transforms incomplete pipelines", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag fixture_pair: "linting/no_else_with_unless"
    test "corrects unless/else to if/else", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag fixture_pair: "linting/no_nil_else"
    test "removes nil else clauses", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag fixture_pair: "linting/true_in_cond"
    test "replaces symbols with true in cond", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag fixture_pair: "linting/use_string_concatenation_when_pattern_matching_binaries"
    test "extracts a final 'bytes' entry when pattern_matching binaries", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag example: "naming/capital_in_atom"
    test "warns when capital letters are used in atoms", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

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
      output = capture_io(:stderr, fn -> format(example) end)

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
      output = capture_io(:stderr, fn -> format(example) end)

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
      output = capture_io(:stderr, fn -> format(example) end)

      assert String.starts_with?(
               output,
               """
               \e[33mwarning:\e[0m capital letter found in attribute name (use snake_case for attribute names)
               2 | @anAttribute
               """
             )
    end

    @tag example: "naming/capital_in_module_struct"
    test "does not warn when the __MODULE__ struct is used", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      assert output == ""
    end

    @tag example: "naming/single_letter_variable"
    test "warns when there are single-letter variable names", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      assert String.starts_with?(
               output,
               """
               \e[33mwarning:\e[0m one-letter variable name found
               2 | i
               """
             )
    end

    @tag fixture_pair: "modules/module_layout"
    test "corrects the order of module references", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag fixture_pair: "modules/replace_current_module_reference"
    test "replaces references to the current module with __MODULE__", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag fixture_pair: "structs/skip_nil_in_struct_definition/key_value"
    test "removes `nil` defaults from struct definitions", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    @tag example: "exceptions/missing_error_suffix"
    test "warns when exceptions are defined without the `Error` suffix", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      assert String.starts_with?(
               output,
               """
               \e[33mwarning:\e[0m exception MissingErrorSuffix should have a suffix of `Error`
               1 | MissingErrorSuffix
               """
             )
    end

    @tag fixture_pair: "parentheses/use_parentheses_with_zero_arity_functions"
    test "adds parentheses to function definitions", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end
  end

  describe "format_file/1" do
    test "fails for filenames with hyphens" do
      %ArgumentError{message: message} =
        try do
          format_file("filename-with-hyphens.ex")
        rescue
          error in ArgumentError ->
            error
        end

      assert message == "'-' found in file name 'filename-with-hyphens.ex'"
    end
  end
end
