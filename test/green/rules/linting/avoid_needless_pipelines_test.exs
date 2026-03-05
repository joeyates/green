defmodule Green.Rules.Linting.AvoidNeedlessPipelinesTest do
  use Green.TestCase, async: true

  alias Green.Rules.Linting.AvoidNeedlessPipelines

  describe "basic transformation" do
    test "transforms single-function pipeline into function call" do
      code = """
      value |> function()
      """

      expected = """
      function(value)
      """

      {forms, comments} = parse_code(code)
      {forms, comments} = AvoidNeedlessPipelines.apply({forms, comments}, [])
      output = default_format({forms, comments})

      assert output == expected
    end

    test "transforms single-function pipeline with arguments" do
      code = """
      value |> function(arg1, arg2)
      """

      expected = """
      function(value, arg1, arg2)
      """

      {forms, comments} = parse_code(code)
      {forms, comments} = AvoidNeedlessPipelines.apply({forms, comments}, [])
      output = default_format({forms, comments})

      assert output == expected
    end

    test "does not transform multi-function pipeline" do
      code = """
      value |> function1() |> function2()
      """

      {forms, comments} = parse_code(code)
      {forms, comments} = AvoidNeedlessPipelines.apply({forms, comments}, [])
      output = default_format({forms, comments})

      assert output == code
    end

    test "does not modify regular function calls" do
      code = """
      function(value)
      """

      {forms, comments} = parse_code(code)
      {forms, comments} = AvoidNeedlessPipelines.apply({forms, comments}, [])
      output = default_format({forms, comments})

      assert output == code
    end
  end

  describe "enabled configuration" do
    test "does not transform when rule is disabled" do
      code = """
      value |> function()
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        AvoidNeedlessPipelines.apply({forms, comments},
          green: [avoid_needless_pipelines: [enabled: false]]
        )

      output = default_format({forms, comments})

      assert output == code
    end
  end

  describe "except configuration" do
    test "skips transformation when entire file is in except list" do
      code = """
      value |> function()
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        AvoidNeedlessPipelines.apply({forms, comments},
          green: [avoid_needless_pipelines: [except: ["test/example.exs"]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when file is in except list
      assert output == code
    end

    test "skips transformation for specific line when in except list" do
      code = """
      value |> function()
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        AvoidNeedlessPipelines.apply({forms, comments},
          green: [avoid_needless_pipelines: [except: [{"test/example.exs", 1}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when line is in except list
      assert output == code
    end

    test "skips transformation for multiple lines when in except list" do
      code = """
      value1 |> function1()

      value2 |> function2()
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        AvoidNeedlessPipelines.apply({forms, comments},
          green: [avoid_needless_pipelines: [except: [{"test/example.exs", [1, 3]}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when lines are in except list
      assert output == code
    end

    test "transforms lines not in except list" do
      code = """
      value1 |> function1()

      value2 |> function2()
      """

      expected = """
      function1(value1)

      value2 |> function2()
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        AvoidNeedlessPipelines.apply({forms, comments},
          green: [avoid_needless_pipelines: [except: [{"test/example.exs", 3}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should transform line 1 but not line 3
      assert output == expected
    end
  end
end
