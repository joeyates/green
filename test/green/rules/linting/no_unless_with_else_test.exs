defmodule Green.Rules.Linting.NoUnlessWithElseTest do
  use Green.TestCase, async: true

  alias Green.Rules.Linting.NoUnlessWithElse

  describe "basic transformation" do
    test "transforms unless with else into if with else" do
      code = """
      unless condition do
        :do_branch
      else
        :else_branch
      end
      """

      expected = """
      if condition do
        :else_branch
      else
        :do_branch
      end
      """

      {forms, comments} = parse_code(code)
      {forms, comments} = NoUnlessWithElse.apply({forms, comments}, [])
      output = default_format({forms, comments})

      assert output == expected
    end
  end

  describe "except configuration" do
    test "skips transformation when entire file is in except list" do
      code = """
      unless condition do
        :do_branch
      else
        :else_branch
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoUnlessWithElse.apply({forms, comments},
          green: [no_unless_with_else: [except: ["test/example.exs"]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when file is in except list
      assert output == code
    end

    test "skips transformation for specific line when in except list" do
      code = """
      unless condition do
        :do_branch
      else
        :else_branch
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoUnlessWithElse.apply({forms, comments},
          green: [no_unless_with_else: [except: [{"test/example.exs", 1}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when line is in except list
      assert output == code
    end

    test "skips transformation for multiple lines when in except list" do
      code = """
      unless condition1 do
        :do_branch1
      else
        :else_branch1
      end

      unless condition2 do
        :do_branch2
      else
        :else_branch2
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoUnlessWithElse.apply({forms, comments},
          green: [no_unless_with_else: [except: [{"test/example.exs", [1, 7]}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when lines are in except list
      assert output == code
    end

    test "transforms lines not in except list" do
      code = """
      unless condition1 do
        :do_branch1
      else
        :else_branch1
      end

      unless condition2 do
        :do_branch2
      else
        :else_branch2
      end
      """

      expected = """
      if condition1 do
        :else_branch1
      else
        :do_branch1
      end

      unless condition2 do
        :do_branch2
      else
        :else_branch2
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoUnlessWithElse.apply({forms, comments},
          green: [no_unless_with_else: [except: [{"test/example.exs", 7}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should transform line 1 but not line 7
      assert output == expected
    end
  end

  defp parse_code(code) do
    to_quoted_opts = [
      unescape: false,
      literal_encoder: &{:ok, {:__block__, &2, [&1]}},
      token_metadata: true,
      emit_warnings: false
    ]

    {forms, comments} = Code.string_to_quoted_with_comments!(code, to_quoted_opts)
    {forms, comments}
  end
end
