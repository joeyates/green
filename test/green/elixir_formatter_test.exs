defmodule Green.ElixirFormatterTest do
  use ExUnit.Case, async: false

  @moduletag :elixir_formatter

  @formatter_project_path "test/projects/elixir_formatter"

  @doc """
  Runs `mix format` on the given code string and returns the formatted result.
  
  This function writes the code to a temporary file in the test project,
  runs the formatter, reads the result, and cleans up.
  """
  def format_code(code) do
    # Create a unique temporary file
    tmp_file = Path.join([@formatter_project_path, "tmp_format_test_#{:erlang.unique_integer()}.ex"])
    
    try do
      # Write the code to the file
      File.write!(tmp_file, code)
      
      # Run mix format in the test project directory
      {output, exit_code} = System.cmd(
        "mix",
        ["format", Path.basename(tmp_file)],
        cd: @formatter_project_path,
        stderr_to_stdout: true
      )
      
      if exit_code != 0 do
        raise "mix format failed with exit code #{exit_code}: #{output}"
      end
      
      # Read the formatted result
      File.read!(tmp_file)
    after
      # Clean up the temporary file
      File.rm(tmp_file)
    end
  end

  @doc """
  Asserts that the formatter transforms the given input code into the expected output.
  """
  def assert_formats(input, expected) do
    actual = format_code(input)
    assert actual == expected, """
    Formatter output did not match expected.
    
    Input:
    #{input}
    
    Expected:
    #{expected}
    
    Actual:
    #{actual}
    """
  end

  @doc """
  Asserts that the formatter does NOT change the given code.
  """
  def assert_unchanged(code) do
    actual = format_code(code)
    assert actual == code, """
    Formatter unexpectedly changed the code.
    
    Input:
    #{code}
    
    Output:
    #{actual}
    """
  end

  # ============================================================================
  # Whitespace Rules
  # ============================================================================

  describe "Whitespace rules" do
    @tag :skip
    test "removes trailing whitespace" do
      # TODO: Implement test
    end

    @tag :skip
    test "ensures newline at end of file" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses Unix-style line endings" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses spaces around operators" do
      # TODO: Implement test
    end

    @tag :skip
    test "no spaces around matched pairs (brackets, braces, parentheses)" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses space after comment #" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses space before -> in 0-arity anonymous functions" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses spaces around default arguments \\\\" do
      # TODO: Implement test
    end

    @tag :skip
    test "no spaces around bitstring segment options" do
      # TODO: Implement test
    end

    @tag :skip
    test "no spaces after unary operators and inside range literals" do
      # TODO: Implement test
    end
  end

  # ============================================================================
  # Indentation Rules
  # ============================================================================

  describe "Indentation rules" do
    @tag :skip
    test "indents right-hand side of binary operators" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses single level indentation for multi-line pipelines" do
      # TODO: Implement test
    end

    @tag :skip
    test "indents and aligns successive with clauses" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses specific indentation for for special form" do
      # TODO: Implement test
    end

    @tag :skip
    test "avoids expression alignment" do
      # TODO: Implement test
    end
  end

  # ============================================================================
  # Numeric Literals Rules
  # ============================================================================

  describe "Numeric Literals rules" do
    @tag :skip
    test "adds underscores to large numeric literals (6+ digits)" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses uppercase letters for hex literals" do
      # TODO: Implement test
    end
  end

  # ============================================================================
  # Atoms and Strings Rules
  # ============================================================================

  describe "Atoms and Strings rules" do
    @tag :skip
    test "uses double quotes (not single) for quoted atoms" do
      # TODO: Implement test
    end

    @tag :skip
    test "preserves string delimiter choices" do
      # TODO: Implement test
    end
  end

  # ============================================================================
  # Data Structures Rules
  # ============================================================================

  describe "Data Structures rules" do
    @tag :skip
    test "no trailing comma on last element of multiline collections" do
      # TODO: Implement test
    end

    @tag :skip
    test "multiline collections have each element on own line" do
      # TODO: Implement test
    end

    @tag :skip
    test "omits square brackets from keyword lists when optional" do
      # TODO: Implement test
    end
  end

  # ============================================================================
  # Control Flow Rules
  # ============================================================================

  describe "Control Flow rules" do
    @tag :skip
    test "choice between :do keyword and do-end blocks left to user" do
      # TODO: Implement test
    end
  end

  # ============================================================================
  # Parentheses Rules
  # ============================================================================

  describe "Parentheses rules" do
    @tag :skip
    test "uses parentheses for zero-arity function calls" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses parentheses in def/defp/defmacro when function has parameters" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses parentheses when calling functions with arguments" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses parentheses for functions in pipe chains" do
      # TODO: Implement test
    end

    @tag :skip
    test "never wraps arguments of anonymous functions in parentheses" do
      # TODO: Implement test
    end

    @tag :skip
    test "no space between function name and opening parenthesis" do
      # TODO: Implement test
    end

    @tag :skip
    test "uses parens on zero-arity types in typespecs" do
      # TODO: Implement test
    end

    @tag :skip
    test "respects :locals_without_parens config for local calls" do
      # TODO: Implement test
    end
  end

  # ============================================================================
  # Layout Rules
  # ============================================================================

  describe "Layout rules" do
    @tag :skip
    test "uses one expression per line (no semicolons)" do
      # TODO: Implement test
    end

    @tag :skip
    test "keeps binary operators at end of line (except |> at beginning)" do
      # TODO: Implement test
    end
  end

  # ============================================================================
  # Comments Rules
  # ============================================================================

  describe "Comments rules" do
    @tag :skip
    test "moves trailing comments to previous line" do
      # TODO: Implement test
    end

    @tag :skip
    test "moves comments around operators before operator usage" do
      # TODO: Implement test
    end
  end
end
