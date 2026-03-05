defmodule Green.Rules.Linting.NoNilElseTest do
  use Green.TestCase, async: true

  alias Green.Rules.Linting.NoNilElse

  describe "basic transformation" do
    test "removes else clause that returns nil" do
      code = """
      if condition do
        :do_branch
      else
        nil
      end
      """

      expected = """
      if condition do
        :do_branch
      end
      """

      {forms, comments} = parse_code(code)
      {forms, comments} = NoNilElse.apply({forms, comments}, [])
      output = default_format({forms, comments})

      assert output == expected
    end

    test "does not remove else clause that returns non-nil value" do
      code = """
      if condition do
        :do_branch
      else
        :else_branch
      end
      """

      {forms, comments} = parse_code(code)
      {forms, comments} = NoNilElse.apply({forms, comments}, [])
      output = default_format({forms, comments})

      assert output == code
    end

    test "does not modify if without else clause" do
      code = """
      if condition do
        :do_branch
      end
      """

      {forms, comments} = parse_code(code)
      {forms, comments} = NoNilElse.apply({forms, comments}, [])
      output = default_format({forms, comments})

      assert output == code
    end
  end

  describe "enabled configuration" do
    test "does not transform when rule is disabled" do
      code = """
      if condition do
        :do_branch
      else
        nil
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoNilElse.apply({forms, comments},
          green: [no_nil_else: [enabled: false]]
        )

      output = default_format({forms, comments})

      assert output == code
    end
  end

  describe "except configuration" do
    test "skips transformation when entire file is in except list" do
      code = """
      if condition do
        :do_branch
      else
        nil
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoNilElse.apply({forms, comments},
          green: [no_nil_else: [except: ["test/example.exs"]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when file is in except list
      assert output == code
    end

    test "skips transformation for specific line when in except list" do
      code = """
      if condition do
        :do_branch
      else
        nil
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoNilElse.apply({forms, comments},
          green: [no_nil_else: [except: [{"test/example.exs", 1}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when line is in except list
      assert output == code
    end

    test "skips transformation for multiple lines when in except list" do
      code = """
      if condition1 do
        :do_branch1
      else
        nil
      end

      if condition2 do
        :do_branch2
      else
        nil
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoNilElse.apply({forms, comments},
          green: [no_nil_else: [except: [{"test/example.exs", [1, 7]}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when lines are in except list
      assert output == code
    end

    test "transforms lines not in except list" do
      code = """
      if condition1 do
        :do_branch1
      else
        nil
      end

      if condition2 do
        :do_branch2
      else
        nil
      end
      """

      expected = """
      if condition1 do
        :do_branch1
      end

      if condition2 do
        :do_branch2
      else
        nil
      end
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        NoNilElse.apply({forms, comments},
          green: [no_nil_else: [except: [{"test/example.exs", 7}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should transform line 1 but not line 7
      assert output == expected
    end
  end
end
