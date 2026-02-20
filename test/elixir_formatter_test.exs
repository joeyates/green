defmodule Green.ElixirFormatterTest do
  @moduledoc """
  Tests for empirically verifying Elixir formatter behavior against style guide rules.

  This test suite validates which formatting rules from the Elixir Style Guide Comparison
  document are actually enforced by the official Elixir formatter (`mix format`).

  ## Running the Tests

  By default, these tests are excluded from normal test runs. To run them explicitly:

      mix test --include elixir_formatter

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

  - `with_formatter_config/1` - Wraps tests with temporary formatter configuration
  - `format_code/1` - Runs `mix format` on code and returns result
  - `assert_formats/2` - Asserts formatter transforms input to expected output
  - `assert_unchanged/1` - Asserts formatter preserves code as-is
  - `assert_fails/1` - Asserts formatter raises an error (for invalid code)

  ## Test Project

  Tests use an isolated Mix project under `test/projects/elixir_formatter/` configured
  for Elixir 1.19.5 to ensure consistent and reproducible formatter behavior.
  """

  use ExUnit.Case, async: false

  @moduletag :elixir_formatter

  @formatter_project_path "test/projects/elixir_formatter"

  @formatter_config_path Path.join(@formatter_project_path, ".formatter.exs")

  @default_formatter_exs [inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]]

  def with_formatter_config(config, test_fun) do
    original_config = File.read!(@formatter_config_path)

    try do
      File.write!(@formatter_config_path, inspect(config))

      test_fun.()
    after
      File.write!(@formatter_config_path, original_config)
    end
  end

  @doc """
  Runs `mix format` on the given code string and returns the formatted result.

  This function writes the code to a temporary file in the test project,
  runs the formatter, reads the result, and cleans up.

  ## Examples

      iex> format_code("defmodule Example do\\ndef hello,do: :world\\nend")
      "defmodule Example do\\n  def hello, do: :world\\nend\\n"

  """
  def format_code(code) do
    tmp_file =
      Path.join([@formatter_project_path, "tmp_format_test_#{:erlang.unique_integer()}.ex"])

    try do
      File.write!(tmp_file, code)

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

      File.read!(tmp_file)
    after
      File.rm(tmp_file)
    end
  end

  @doc """
  Asserts that the formatter transforms the given input code into the expected output.
  """
  def assert_formats(input, expected) do
    actual = format_code(input)

    assert actual == expected
  end

  @doc """
  Asserts that the formatter does not change the given code.
  """
  def assert_unchanged(code) do
    actual = format_code(code)

    assert actual == code
  end

  @doc """
  Asserts that the formatter raises an error when given invalid code.
  """
  def assert_fails(code) do
    assert_raise RuntimeError, ~r/mix format failed/, fn ->
      format_code(code)
    end
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
      input = "defmodule Example do\n  def hello, do: :world\nend"

      expected = "#{input}\n"

      assert_formats(input, expected)
    end

    test "enforces Unix-style line endings" do
      # Input with Windows line endings
      input = "defmodule Example do\r\n  def hello, do: :world\r\nend\r\n"

      expected = "defmodule Example do\n  def hello, do: :world\nend\n"

      assert_formats(input, expected)
    end

    test "ensures two-space indentation" do
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

    test "ensures a single space around operators" do
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

    test "removes spaces inside matched pairs (brackets, braces, parentheses)" do
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

    test "inserts a space after comment #" do
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

    test "ensures a space before -> in 0-arity anonymous functions" do
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

    test "ensures a space around default arguments \\\\" do
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

    test "removes spaces around bitstring segment options" do
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

    test "removes spaces after unary operators and inside range literals" do
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

    test "fails when there's a space between function name and opening parenthesis" do
      input = """
      defmodule Example do
        def example do
          result = calculate (1, 2, 3)
        end
      end
      """

      assert_fails(input)
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

    test "enforces single level indentation for multi-line pipelines" do
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

    test "aligns successive 'with' clauses" do
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

    test "aligns successive 'for' clauses" do
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

    test "resets alignment of the match (=) operator" do
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

    test "enforces uppercase letters for hex literals" do
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
    test "enforces double quotes (not single) for quoted atoms" do
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

    test "preserves charlist single quote syntax (does not convert to ~c sigil)" do
      code = """
      defmodule Example do
        def example do
          str1 = "hello"
          str2 = 'world'
        end
      end
      """

      assert_unchanged(code)
    end
  end

  # ============================================================================
  # Data Structures Rules
  # ============================================================================

  describe "Data Structures rules" do
    test "removes trailing commas from single-line collections" do
      input = """
      defmodule Example do
        def example do
          list = [1, 2, 3,]
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          list = [1, 2, 3]
        end
      end
      """

      assert_formats(input, expected)
    end

    test "removes trailing comma on last element of multiline collections" do
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

    test "collects multiline collections on a single line when possible" do
      input = """
      defmodule Example do
        def example do
          list = [1, 2,
            3, 4]
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          list = [1, 2, 3, 4]
        end
      end
      """

      assert_formats(input, expected)
    end

    test "breaks collections across multiple lines when lines are too long" do
      input = """
      defmodule Example do
        def example do
          list = [some_long_function_name(), another_very_long_function(), yet_another_very_long_function()]
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          list = [
            some_long_function_name(),
            another_very_long_function(),
            yet_another_very_long_function()
          ]
        end
      end
      """

      assert_formats(input, expected)
    end

    test "leaves collections on multiple lines if there is a newline after the opening delimiter" do
      input = """
      defmodule Example do
        def example do
          list = [
            1, 2, 3
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
    test "does not collapse short do-end blocks into :do keyword" do
      code = """
      defmodule Example do
        def short do
          :ok
        end
      end
      """

      assert_unchanged(code)
    end

    test "does not expand long :do keyword blocks into do-end" do
      code = """
      defmodule Example do
        def long,
          do:
            [1..100]
            |> Enum.filter(&(div(&1, 2) == 0))
            |> Enum.map(&(&1 * 2))
            |> Enum.filter(&(&1 > 100))
            |> Enum.sum()
      end
      """

      assert_unchanged(code)
    end
  end

  # ============================================================================
  # Parentheses Rules
  # ============================================================================

  describe "Parentheses rules" do
    test "does not add parentheses to zero-arity function calls" do
      code = """
      defmodule Example do
        def example do
          result = some_zero_arity_function
        end
      end
      """

      assert_unchanged(code)
    end

    test "adds parentheses to def/defp/defmacro/defmacrop when function has parameters" do
      input = ~S"""
      defmodule Example do
        def greet name do
          "Hello, " <> name
        end

        defp up string do
          String.upcase(string)
        end

        defmacro example_macro arg do
          quote do
            IO.puts("This is a macro with arg: #{arg}")
          end
        end

        defmacrop another_macro arg do
          quote do
            IO.puts("Another macro with arg: #{arg}")
          end
        end
      end
      """

      expected = ~S"""
      defmodule Example do
        def greet(name) do
          "Hello, " <> name
        end

        defp up(string) do
          String.upcase(string)
        end

        defmacro example_macro(arg) do
          quote do
            IO.puts("This is a macro with arg: #{arg}")
          end
        end

        defmacrop another_macro(arg) do
          quote do
            IO.puts("Another macro with arg: #{arg}")
          end
        end
      end
      """

      assert_formats(input, expected)
    end

    test "adds parentheses when calling functions with arguments" do
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

    test "removes parentheses from arguments of anonymous functions" do
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

    test "does not add parens to zero-arity global types in typespecs" do
      code = """
      defmodule Example do
        @type my_type :: integer | atom
      end
      """

      assert_unchanged(code)
    end

    test "does not remove parens from zero-arity global types in typespecs" do
      code = """
      defmodule Example do
        @type my_type :: integer() | atom()
      end
      """

      assert_unchanged(code)
    end

    test "add parens to module-scoped types in typespecs" do
      input = """
      defmodule Example do
        @type my_type :: String.t
      end
      """

      expected = """
      defmodule Example do
        @type my_type :: String.t()
      end
      """

      assert_formats(input, expected)
    end

    test "respects :locals_without_parens config for local calls" do
      input = """
      defmodule Example do
        import String

        def example do
          upcase "hello"
        end
      end
      """

      expected = """
      defmodule Example do
        import String

        def example do
          upcase "hello"
        end
      end
      """

      config = Keyword.put(@default_formatter_exs, :locals_without_parens, upcase: 1)

      with_formatter_config(config, fn ->
        assert_formats(input, expected)
      end)
    end

    test "fails when there are unbalanced parentheses in typespecs" do
      input = """
      defmodule Example do
        @type my_type :: list(integer
      end
      """

      assert_fails(input)
    end
  end

  # ============================================================================
  # Layout Rules
  # ============================================================================

  describe "Layout rules" do
    test "enforces one expression per line (no semicolons)" do
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

    test "when a **possibly** unary operator is placed at the beginning of a line, it is treated as unary" do
      input = """
      defmodule Example do
        def example do
          1
           + 2
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          1
          +2
        end
      end
      """

      assert_formats(input, expected)
    end

    test "when non-unary operators are placed at the beginning of a line, they are moved to the end of the previous line" do
      input = """
      defmodule Example do
        def example do
          2
          * 3
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          2 *
            3
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

    test "when comments are between terms separated by operators, it moves the comment before the expression" do
      code = """
      defmodule Example do
        def example do
          a +
          # add b
            b
        end
      end
      """

      expected = """
      defmodule Example do
        def example do
          # add b
          a +
            b
        end
      end
      """

      assert_formats(code, expected)
    end
  end
end
