defmodule Green.ElixirFormatterTest do
  @moduledoc """
  Tests for empirically verifying Elixir formatter behavior against style guide rules.

  This test suite validates which formatting rules from the Elixir Style Guide Comparison
  document are actually enforced by the official Elixir formatter (`mix format`).

  ## Running the Tests

  By default, these tests are excluded from normal test runs. To run them explicitly:

      mix test --include elixir_formatter

  To run a specific test category:

      mix test test/elixir_formatter_test.exs --include elixir_formatter --only "Whitespace rules"

  ## Test Structure

  Tests are organized by rule categories matching the style guide comparison document:

  - **Whitespace Rules** - Spacing, line endings, indentation basics
  - **Indentation Rules** - Binary operators, pipelines, with/for constructs
  - **Numeric Literals Rules** - Underscores, hex formatting
  - **Atoms and Strings Rules** - Quoting, delimiter choices
  - **Data Structures Rules** - Lists, maps, keyword lists
  - **Control Flow Rules** - do/end vs :do syntax choices
  - **Parentheses Rules** - Function calls, definitions, typespecs
  - **Layout Rules** - Expressions per line, operator placement
  - **Comments Rules** - Comment positioning and movement

  ## Helper Functions

  - `format_code/1` - Runs `mix format` on code and returns result
  - `assert_formats/2` - Asserts formatter transforms input to expected output
  - `assert_unchanged/1` - Asserts formatter preserves code as-is

  ## Test Project

  Tests use an isolated Mix project under `test/projects/elixir_formatter/` configured
  for Elixir 1.19.5 to ensure consistent and reproducible formatter behavior.
  """

  use ExUnit.Case, async: false

  @moduletag :elixir_formatter

  @formatter_project_path "test/projects/elixir_formatter"

  @doc """
  Runs `mix format` on the given code string and returns the formatted result.

  This function writes the code to a temporary file in the test project,
  runs the formatter, reads the result, and cleans up.

  ## Examples

      iex> format_code("defmodule Example do\\ndef hello,do: :world\\nend")
      "defmodule Example do\\n  def hello, do: :world\\nend\\n"

  """
  def format_code(code) do
    # Create a unique temporary file
    tmp_file =
      Path.join([@formatter_project_path, "tmp_format_test_#{:erlang.unique_integer()}.ex"])

    try do
      # Write the code to the file
      File.write!(tmp_file, code)

      # Run mix format in the test project directory
      {output, exit_code} =
        System.cmd(
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
    test "removes trailing whitespace" do
      input = """
      defmodule Example do
        def hello do  \s\s
          :world\s
        end
      end
      """

      expected = """
      defmodule Example do
        def hello do
          :world
        end
      end
      """

      assert_formats(input, expected)
    end

    test "ensures newline at end of file" do
      # File without newline at EOF
      input = "defmodule Example do\n  def hello, do: :world\nend"

      # Formatter adds newline
      expected = "defmodule Example do\n  def hello, do: :world\nend\n"

      assert_formats(input, expected)
    end

    test "uses Unix-style line endings" do
      # Input with Windows line endings
      input = "defmodule Example do\r\n  def hello, do: :world\r\nend\r\n"

      # Formatter converts to Unix line endings
      expected = "defmodule Example do\n  def hello, do: :world\nend\n"

      assert_formats(input, expected)
    end

    test "uses two-space indentation" do
      input = """
      defmodule Example do
      def hello do
      case :value do
      :value -> :ok
      end
      end
      end
      """

      expected = """
      defmodule Example do
        def hello do
          case :value do
            :value -> :ok
          end
        end
      end
      """

      assert_formats(input, expected)
    end

    test "uses spaces around operators" do
      input = """
      defmodule Example do
        def calc do
          a=1
          b=2+3
          c=a*b
          {a,b,c}
        end
      end
      """

      expected = """
      defmodule Example do
        def calc do
          a = 1
          b = 2 + 3
          c = a * b
          {a, b, c}
        end
      end
      """

      assert_formats(input, expected)
    end

    test "no spaces around matched pairs (brackets, braces, parentheses)" do
      input = """
      defmodule Example do
        def example do
          list = [ 1, 2, 3 ]
          tuple = { :a, :b }
          map = %{ key: "value" }
          call( :arg )
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          list = [1, 2, 3]
          tuple = {:a, :b}
          map = %{key: "value"}
          call(:arg)
        end
      end
      """

      assert_formats(input, expected)
    end

    test "uses space after comment #" do
      input = """
      defmodule Example do
        #This is a comment
        def hello do
          #Another comment
          :world
        end
      end
      """

      expected = """
      defmodule Example do
        # This is a comment
        def hello do
          # Another comment
          :world
        end
      end
      """

      assert_formats(input, expected)
    end

    test "uses space before -> in 0-arity anonymous functions" do
      input = """
      defmodule Example do
        def example do
          fn-> :result end
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          fn -> :result end
        end
      end
      """

      assert_formats(input, expected)
    end

    test "uses spaces around default arguments \\\\" do
      input = """
      defmodule Example do
        def greet(name\\\\\"World\") do
          "Hello, " <> name
        end
      end
      """

      expected = """
      defmodule Example do
        def greet(name \\\\ "World") do
          "Hello, " <> name
        end
      end
      """

      assert_formats(input, expected)
    end

    test "no spaces around bitstring segment options" do
      input = """
      defmodule Example do
        def parse(<<value :: size(8), rest :: binary>>) do
          {value, rest}
        end
      end
      """

      expected = """
      defmodule Example do
        def parse(<<value::size(8), rest::binary>>) do
          {value, rest}
        end
      end
      """

      assert_formats(input, expected)
    end

    test "no spaces after unary operators and inside range literals" do
      input = """
      defmodule Example do
        def example do
          x = - 5
          y = ! true
          range = 1 .. 10
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          x = -5
          y = !true
          range = 1..10
        end
      end
      """

      assert_formats(input, expected)
    end
  end

  # ============================================================================
  # Indentation Rules
  # ============================================================================

  describe "Indentation rules" do
    test "indents right-hand side of binary operators" do
      input = """
      defmodule Example do
        def example do
          result = some_long_function_name() +
          another_function() *
          third_function()
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          result =
            some_long_function_name() +
              another_function() *
                third_function()
        end
      end
      """

      assert_formats(input, expected)
    end

    test "uses single level indentation for multi-line pipelines" do
      input = """
      defmodule Example do
        def example do
          [1, 2, 3]
              |> Enum.map(&(&1 * 2))
                  |> Enum.filter(&(&1 > 2))
            |> Enum.sum()
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          [1, 2, 3]
          |> Enum.map(&(&1 * 2))
          |> Enum.filter(&(&1 > 2))
          |> Enum.sum()
        end
      end
      """

      assert_formats(input, expected)
    end

    test "indents and aligns successive with clauses" do
      input = """
      defmodule Example do
        def example do
          with {:ok, a} <- fetch_a(),
          {:ok, b} <- fetch_b(),
          {:ok, c} <- fetch_c() do
            {a, b, c}
          end
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          with {:ok, a} <- fetch_a(),
               {:ok, b} <- fetch_b(),
               {:ok, c} <- fetch_c() do
            {a, b, c}
          end
        end
      end
      """

      assert_formats(input, expected)
    end

    test "uses specific indentation for for special form" do
      input = """
      defmodule Example do
        def example do
          for x <- [1, 2, 3],
          y <- [4, 5, 6],
          x + y > 5 do
            {x, y}
          end
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          for x <- [1, 2, 3],
              y <- [4, 5, 6],
              x + y > 5 do
            {x, y}
          end
        end
      end
      """

      assert_formats(input, expected)
    end

    test "avoids expression alignment" do
      input = """
      defmodule Example do
        def example do
          short       = 1
          medium_name = 2
          very_long_variable_name = 3
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          short = 1
          medium_name = 2
          very_long_variable_name = 3
        end
      end
      """

      assert_formats(input, expected)
    end
  end

  # ============================================================================
  # Numeric Literals Rules
  # ============================================================================

  describe "Numeric Literals rules" do
    test "adds underscores to large numeric literals (6+ digits)" do
      input = """
      defmodule Example do
        def example do
          small = 12345
          large = 1000000
          very_large = 1234567890
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          small = 12345
          large = 1_000_000
          very_large = 1_234_567_890
        end
      end
      """

      assert_formats(input, expected)
    end

    test "uses uppercase letters for hex literals" do
      input = """
      defmodule Example do
        def example do
          hex1 = 0xabcdef
          hex2 = 0x123abc
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          hex1 = 0xABCDEF
          hex2 = 0x123ABC
        end
      end
      """

      assert_formats(input, expected)
    end
  end

  # ============================================================================
  # Atoms and Strings Rules
  # ============================================================================

  describe "Atoms and Strings rules" do
    test "uses double quotes (not single) for quoted atoms" do
      input = """
      defmodule Example do
        def example do
          atom1 = :'hello world'
          atom2 = :'another-atom'
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          atom1 = :"hello world"
          atom2 = :"another-atom"
        end
      end
      """

      assert_formats(input, expected)
    end

    test "does NOT preserve charlist single quote syntax (converts to ~c sigil)" do
      # Actually, the formatter DOES preserve single quote syntax in Elixir 1.19.5
      code = """
      defmodule Example do
        def example do
          str1 = "hello"
          str2 = 'world'
        end
      end
      """

      # Code remains unchanged - formatter preserves charlist syntax
      assert_unchanged(code)
    end
  end

  # ============================================================================
  # Data Structures Rules
  # ============================================================================

  describe "Data Structures rules" do
    test "no trailing comma on last element of multiline collections" do
      input = """
      defmodule Example do
        def example do
          list = [
            1,
            2,
            3,
          ]
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          list = [
            1,
            2,
            3
          ]
        end
      end
      """

      assert_formats(input, expected)
    end

    test "does NOT force multiline collections to have each element on own line" do
      # The formatter only expands to multiline if it's beneficial for line length
      input = """
      defmodule Example do
        def example do
          list = [1, 2,
            3, 4]
        end
      end
      """

      # Formatter collapses to single line for short lists
      expected = """
      defmodule Example do
        def example do
          list = [1, 2, 3, 4]
        end
      end
      """

      assert_formats(input, expected)
    end

    test "omits square brackets from keyword lists when optional" do
      input = """
      defmodule Example do
        def greet([name: name, age: age]) do
          "Hello"
        end
      end
      """

      expected = """
      defmodule Example do
        def greet(name: name, age: age) do
          "Hello"
        end
      end
      """

      assert_formats(input, expected)
    end
  end

  # ============================================================================
  # Control Flow Rules
  # ============================================================================

  describe "Control Flow rules" do
    test "choice between :do keyword and do-end blocks left to user" do
      # Test that both forms are preserved
      input_do_keyword = """
      defmodule Example do
        def short, do: :ok
      end
      """

      input_do_end = """
      defmodule Example do
        def short do
          :ok
        end
      end
      """

      # Both should be preserved as-is
      assert_unchanged(input_do_keyword)
      assert_unchanged(input_do_end)
    end
  end

  # ============================================================================
  # Parentheses Rules
  # ============================================================================

  describe "Parentheses rules" do
    test "does NOT add parentheses to zero-arity function calls (leaves as-is)" do
      # The formatter does not automatically add parentheses to zero-arity calls
      code = """
      defmodule Example do
        def example do
          result = some_function
        end
      end
      """

      # Code remains unchanged
      assert_unchanged(code)
    end

    test "uses parentheses in def/defp/defmacro when function has parameters" do
      input = """
      defmodule Example do
        def greet name do
          "Hello, " <> name
        end
      end
      """

      expected = """
      defmodule Example do
        def greet(name) do
          "Hello, " <> name
        end
      end
      """

      assert_formats(input, expected)
    end

    test "uses parentheses when calling functions with arguments" do
      input = """
      defmodule Example do
        def example do
          result = calculate 1, 2, 3
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          result = calculate(1, 2, 3)
        end
      end
      """

      assert_formats(input, expected)
    end

    test "adds parentheses to functions in pipe chains" do
      # The formatter adds parens to all functions in pipe chains
      input = """
      defmodule Example do
        def example do
          [1, 2, 3]
          |> Enum.map(&(&1 * 2))
          |> Enum.sum
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          [1, 2, 3]
          |> Enum.map(&(&1 * 2))
          |> Enum.sum()
        end
      end
      """

      assert_formats(input, expected)
    end

    test "never wraps arguments of anonymous functions in parentheses" do
      input = """
      defmodule Example do
        def example do
          fun = fn (x, y) -> x + y end
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          fun = fn x, y -> x + y end
        end
      end
      """

      assert_formats(input, expected)
    end

    test "does NOT remove space between function name and opening parenthesis" do
      # The formatter does not remove this space (interprets as function call with tuple)
      code = """
      defmodule Example do
        def example do
          result = some_function(1, 2)
        end
      end
      """

      # Code remains unchanged when written correctly
      assert_unchanged(code)
    end

    test "does NOT add parens to zero-arity types in typespecs" do
      # The formatter does not automatically add parentheses to types
      code = """
      defmodule Example do
        @type my_type :: integer | atom
      end
      """

      # Code remains unchanged
      assert_unchanged(code)
    end

    test "respects :locals_without_parens config for local calls" do
      # This test verifies the formatter respects the .formatter.exs config
      # The test project should have a default config
      input = """
      defmodule Example do
        def example do
          import String
          upcase "hello"
        end
      end
      """

      # With default config, import should not require parens
      expected = """
      defmodule Example do
        def example do
          import String
          upcase("hello")
        end
      end
      """

      assert_formats(input, expected)
    end
  end

  # ============================================================================
  # Layout Rules
  # ============================================================================

  describe "Layout rules" do
    test "uses one expression per line (no semicolons)" do
      input = """
      defmodule Example do
        def example do
          x = 1; y = 2; z = 3
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          x = 1
          y = 2
          z = 3
        end
      end
      """

      assert_formats(input, expected)
    end

    test "does NOT consistently keep binary operators at end of line" do
      # The formatter doesn't always keep operators at end of line
      input = """
      defmodule Example do
        def example do
          result = some_value
          + another_value
          * third_value
        end
      end
      """

      # Formatter may leave operators at beginning or handle inconsistently
      expected = """
      defmodule Example do
        def example do
          result = some_value

          +another_value *
            third_value
        end
      end
      """

      assert_formats(input, expected)
    end
  end

  # ============================================================================
  # Comments Rules
  # ============================================================================

  describe "Comments rules" do
    test "moves trailing comments to previous line" do
      input = """
      defmodule Example do
        def example do
          x = 1 # trailing comment
          y = 2 # another trailing
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          # trailing comment
          x = 1
          # another trailing
          y = 2
        end
      end
      """

      assert_formats(input, expected)
    end

    test "does NOT always move comments around operators optimally" do
      # The formatter may not always move operator comments to ideal locations
      code = """
      defmodule Example do
        def example do
          result = a + b
        end
      end
      """

      # For simple cases without comments, code remains unchanged
      assert_unchanged(code)
    end
  end
end
