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

  @tag fixture_pair: "linting/avoid_needless_pipelines"
  test "supports configuration to disable avoid_needless_pipelines rule", %{bad: unchanged} do
    formatted = format(unchanged, green: [avoid_needless_pipelines: [enabled: false]])

    assert formatted == unchanged
  end

  @tag fixture_pair: "linting/incomplete_pipeline"
  test "transforms incomplete pipelines", %{bad: bad, good: good} do
    formatted = format(bad)

    assert formatted == good
  end

  describe "unless with else" do
    @describetag fixture_pair: "linting/no_unless_with_else"

    test "transforms unless with else into if with else", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    test "supports configuration to disable no_unless_with_else rule", %{bad: unchanged} do
      formatted = format(unchanged, green: [no_unless_with_else: [enabled: false]])

      assert formatted == unchanged
    end
  end

  describe "nil else clauses" do
    @describetag fixture_pair: "linting/no_nil_else"

    test "are removed", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    test "supports configuration to disable no_nil_else rule", %{bad: unchanged} do
      formatted = format(unchanged, green: [no_nil_else: [enabled: false]])

      assert formatted == unchanged
    end
  end

  describe "when the match-all clause in cond is not `true`" do
    @describetag fixture_pair: "linting/true_in_cond"

    test "replaces symbols with true", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    test "supports configuration to disable true_in_cond rule", %{bad: unchanged} do
      formatted = format(unchanged, green: [true_in_cond: [enabled: false]])

      assert formatted == unchanged
    end
  end

  describe "when pattern_matching binaries" do
    @describetag fixture_pair: "linting/use_string_concatenation_when_matching_binaries"

    test "extracts a final 'bytes' entry", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    test "supports configuration to disable use_string_concatenation_when_matching_binaries rule", %{
      bad: unchanged
    } do
      formatted =
        format(unchanged,
          green: [use_string_concatenation_when_matching_binaries: [enabled: false]]
        )

      assert formatted == unchanged
    end
  end

  describe "when anonymous functions are used in pipelines" do
    @describetag example: "linting/anonymous_pipeline"

    test "warns", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m anonymous function found in pipeline (consider defining a named function instead)
        7 | (fn words -> [@sentence_start | words] end).()
        """
      )
    end

    test "supports configuration to disable no_anonymous_functions_in_pipelines rule", %{example: example} do
      output =
        capture_io(:stderr, fn ->
          format(example, green: [no_anonymous_functions_in_pipelines: [enabled: false]])
        end)

      assert output == ""
    end
  end

  describe "when &&/||/! is used for strictly boolean checks" do
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

    test "supports configuration to disable boolean_operators rule", %{example: example} do
      output =
        capture_io(:stderr, fn ->
          format(example, green: [boolean_operators: [enabled: false]])
        end)

      assert output == ""
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

    test "doesn't warn when local non-boolean function call is second operand", %{
      example: example
    } do
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
    assert_warns(
      example,
      """
      \e[33mwarning:\e[0m capital letter found in atom (use snake_case for atoms)
      3 | :someAtom
      """
    )
  end

  @tag example: "naming/capital_in_function_name"
  test "warns when capital letters are used in function names", %{example: example} do
    assert_warns(
      example,
      """
      \e[33mwarning:\e[0m capital letter found in function name (use snake_case for function names)
      2 | capital_in_Function_name
      """
    )
  end

  @tag example: "naming/capital_in_variable_name"
  test "warns when capital letters are used in variable names", %{example: example} do
    assert_warns(
      example,
      """
      \e[33mwarning:\e[0m capital letter found in variable name (use snake_case for variable names)
      3 | _myVariable
      """
    )
  end

  @tag example: "naming/capital_in_attribute_name"
  test "warns when capital letters are used in attribute names", %{example: example} do
    assert_warns(
      example,
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
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m found badly formed module name (use UpperCamelCase for module names)
        1 | defmodule :appStack do
        """
      )
    end

    test "warns with underscores in module names", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m found badly formed module name (use UpperCamelCase for module names)
        5 | defmodule App_Stack do
        """
      )
    end

    test "supports configuration to disable upper_camel_case_for_modules rule", %{example: example} do
      output =
        capture_io(:stderr, fn ->
          format(example, green: [upper_camel_case_for_modules: [enabled: false]])
        end)

      refute output =~ "found badly formed module name (use UpperCamelCase for module names)"
    end
  end

  describe "warns when there are single-letter variable names" do
    @describetag example: "naming/single_letter_variable"
    test "warns", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m one-letter variable name found
        2 | i
        """
      )
    end

    test "supports configuration to disable avoid_one_letter_variables rule", %{example: example} do
      output =
        capture_io(:stderr, fn ->
          format(example, green: [avoid_one_letter_variables: [enabled: false]])
        end)

      assert output == ""
    end
  end

  describe "predicate functions" do
    @describetag example: "naming/predicate_funs_name"

    test "warns when predicate functions don't have ? suffix", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m predicate function should have `?` suffix
        3 | def is_even(number) do
        """
      )
    end

    test "warns when guard-style macros have ? suffix", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m guard-style macros should not have `?` suffix, use `is_` prefix instead
        12 | defmacro valid?(value) do
        """
      )
    end

    test "supports configuration to disable predicate_functions rule", %{example: example} do
      output =
        capture_io(:stderr, fn ->
          format(example, green: [predicate_functions: [enabled: false]])
        end)

      assert output == ""
    end
  end

  describe "when the order of module references is wrong" do
    @describetag fixture_pair: "modules/module_layout"
    test "corrects the order of module references", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    test "supports configuration to disable sort_module_references rule", %{bad: unchanged} do
      formatted = format(unchanged, green: [sort_module_references: [enabled: false]])

      assert formatted == unchanged
    end
  end

  describe "when there are references to the current module" do
    @describetag fixture_pair: "modules/replace_current_module_reference"
    test "replaces references to the current module with __MODULE__", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    test "supports configuration to disable use_module_pseudo_variable rule", %{bad: unchanged} do
      formatted = format(unchanged, green: [use_module_pseudo_variable: [enabled: false]])

      assert formatted == unchanged
    end
  end


  describe "when `nil` defaults are used in struct definitions" do
    @describetag fixture_pair: "structs/skip_nil_in_struct_definition/key_value"

    test "removes the `nil`", %{bad: bad, good: good} do
      formatted = format(bad)

      assert formatted == good
    end

    test "supports configuration to disable remove_nil_from_struct_definition rule", %{bad: unchanged} do
      formatted = format(unchanged, green: [remove_nil_from_struct_definition: [enabled: false]])

      assert formatted == unchanged
     end
  end

  describe "when exceptions are defined without the `Error` suffix" do
    @describetag example: "exceptions/missing_error_suffix"

    test "warns", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m exception MissingErrorSuffix should have a suffix of `Error`
        1 | MissingErrorSuffix
        """
      )
    end

    test "supports configuration to disable use_error_suffix rule", %{example: example} do
      output =
        capture_io(:stderr, fn ->
          format(example, green: [use_error_suffix: [enabled: false]])
        end)

      assert output == ""
     end
  end

  describe "when exception messages are capitalized" do
    @describetag example: "exceptions/exception_message"

    test "warns", %{example: example} do
      assert_warns(
        example,
        """
        \e[33mwarning:\e[0m exception message should be lowercase
        4 | raise RuntimeError, "Invalid input"
        """
      )
    end

    test "supports configuration to disable lowercase_exception_messages rule", %{example: example} do
      output =
        capture_io(:stderr, fn ->
          format(example, green: [lowercase_exception_messages: [enabled: false]])
        end)

      refute output =~ "exception message should be lowercase"
     end
  end

  @tag example: "exceptions/exception_message"
  test "warns when exception messages have trailing punctuation", %{example: example} do
    assert_warns(
      example,
      """
      \e[33mwarning:\e[0m exception message should not have trailing punctuation
      9 | raise ArgumentError, "invalid argument!"
      """
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
