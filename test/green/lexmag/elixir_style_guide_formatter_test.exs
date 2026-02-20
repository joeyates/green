defmodule Green.Lexmag.ElixirStyleGuideFormatterTest do
  use Green.TestCase, async: true

  import Green.Lexmag.ElixirStyleGuideFormatter
  import ExUnit.CaptureIO

  def assert_warns(code, warning) do
    output = capture_io(:stderr, fn -> format(code) end)

    assert output =~ warning
  end

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

  @tag example: "linting/anonymous_pipeline"
  test "warns when anonymous functions are used in pipelines", %{example: example} do
    output = capture_io(:stderr, fn -> format(example) end)

    assert String.starts_with?(
              output,
              """
              \e[33mwarning:\e[0m anonymous function found in pipeline (consider defining a named function instead)
              7 | (fn words -> [@sentence_start | words] end).()
              """
            )
  end

  describe "warns when &&/||/! is used for strictly boolean checks" do
    @describetag example: "linting/boolean_operators"

    test "warns for boolean value &&/|| boolean value", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `and` instead of `&&` for boolean checks
        4 | true && false
        """
      )
    end

    test "doesn't warn for boolean value and/or boolean value", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "8 | true and false")
    end

    test "warns for boolean value &&/|| guard style", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `or` instead of `||` for boolean checks
        12 | false || is_atom(name)
        """
      )
    end

    test "doesn't warn for boolean value and/or guard style", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "16 | false or is_atom(name)")
    end

    test "warns for boolean value &&/|| predicate", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `and` instead of `&&` for boolean checks
        20 | false && really?(name)
        """
      )
    end

    test "doesn't warn for boolean value and/or predicate", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "24 | false and really?(name)")
    end

    test "warns for boolean value &&/|| comparison", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `or` instead of `||` for boolean checks
        28 | false || name == :foo
        """
      )
    end

    test "doesn't warn for boolean value and/or comparison", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "32 | false or name == :foo")
    end

    test "warns for guard style &&/|| boolean value", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `and` instead of `&&` for boolean checks
        36 | is_atom(name) && true
        """
      )
    end

    test "doesn't warn for guard style and/or boolean value", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "40 | is_atom(name) and true")
    end

    test "warns for guard style &&/|| predicate", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `or` instead of `||` for boolean checks
        44 | is_atom(name) || really?(name)
        """
      )
    end

    test "doesn't warn for guard style and/or predicate", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "48 | is_atom(name) or really?(name)")
    end

    test "warns for guard style &&/|| comparison", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `and` instead of `&&` for boolean checks
        52 | is_atom(name) && name != nil
        """
      )
    end

    test "doesn't warn for guard style and/or comparison", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "56 | is_atom(name) and name != nil")
    end

    test "warns for predicate &&/|| boolean value", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `or` instead of `||` for boolean checks
        60 | really?(name) || true
        """
      )
    end

    test "doesn't warn for predicate and/or boolean value", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "64 | really?(name) or true")
    end

    test "warns for predicate &&/|| guard style", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `and` instead of `&&` for boolean checks
        68 | really?(name) && is_atom(name)
        """
      )
    end

    test "doesn't warn for predicate and/or guard style", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "72 | really?(name) and is_atom(name)")
    end

    test "warns for predicate &&/|| comparison", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `or` instead of `||` for boolean checks
        76 | really?(name) || name != nil
        """
      )
    end

    test "doesn't warn for predicate and/or comparison", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "80 | really?(name) or name != nil")
    end

    test "doesn't warn when value is first operand", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "85 | 1 && true")
    end

    test "doesn't warn when local non-boolean function call is first operand", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "89 | title(name) || false")
    end

    test "doesn't warn when module function call is first operand", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "93 | Foo.bar(baz) && correct?(baz)")
    end

    test "doesn't warn when value is second operand", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "99 | true && 1")
    end

    test "doesn't warn when local non-boolean function call is second operand", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "103 | false || title(name)")
    end

    test "doesn't warn when module function call is second operand", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "107 | correct?(baz) && Foo.bar(baz)")
    end

    test "warns for ! boolean value", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `not` instead of `!` for boolean checks
        114 | !true
        """
      )
    end

    test "doesn't warn for not boolean value", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "118 | not true")
    end

    test "warns for ! guard style", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `not` instead of `!` for boolean checks
        122 | !is_atom(name)
        """
      )
    end

    test "doesn't warn for not guard style", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "126 | not is_atom(name)")
    end

    test "warns for ! predicate", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `not` instead of `!` for boolean checks
        130 | !really?(name)
        """
      )
    end

    test "doesn't warn for not predicate", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "134 | not really?(name)")
    end

    test "warns for ! comparison", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m use `not` instead of `!` for boolean checks
        138 | !(name == :foo)
        """
      )
    end

    test "doesn't warn for not comparison", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      refute String.contains?(output, "142 | not (name == :foo)")
    end
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

  describe "when module names don't use CamelCase" do
    @describetag example: "naming/camelcase_modules"

    test "warns for lower camel-case module names", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      assert String.contains?(
                output,
                """
                \e[33mwarning:\e[0m found badly formed module name (use UpperCamelCase for module names)
                1 | defmodule :appStack do
                """
              )
    end

    test "warns with underscores in module names", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      assert String.contains?(
                output,
                """
                \e[33mwarning:\e[0m found badly formed module name (use UpperCamelCase for module names)
                5 | defmodule App_Stack do
                """
              )
    end
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

  describe "predicate functions" do
    @describetag example: "naming/predicate_funs_name"

    test "warns when predicate functions don't have ? suffix", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      assert String.contains?(
                output,
                """
                \e[33mwarning:\e[0m predicate function should have `?` suffix
                3 | def is_even(number) do
                """
              )
    end

    test "warns when guard-style macros have ? suffix", %{example: example} do
      output = capture_io(:stderr, fn -> format(example) end)

      assert String.contains?(
                output,
                """
                \e[33mwarning:\e[0m guard-style macros should not have `?` suffix, use `is_` prefix instead
                12 | defmacro valid?(value) do
                """
              )
    end
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

  @tag example: "exceptions/exception_message"
  test "warns when exception messages are capitalized", %{example: example} do
    output = capture_io(:stderr, fn -> format(example) end)

    assert String.contains?(
              output,
              """
              \e[33mwarning:\e[0m exception message should be lowercase
              4 | raise RuntimeError, "Invalid input"
              """
            )
  end

  @tag example: "exceptions/exception_message"
  test "warns when exception messages have trailing punctuation", %{example: example} do
    output = capture_io(:stderr, fn -> format(example) end)

    assert String.contains?(
              output,
              "\e[33mwarning:\e[0m exception message should not have trailing punctuation"
            )
  end

  @tag fixture_pair: "parentheses/use_parentheses_with_zero_arity_functions"
  test "adds parentheses to function definitions", %{bad: bad, good: good} do
    formatted = format(bad)

    assert formatted == good
  end

  describe "format_file/2" do
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
