# green:configure-for-this-file Naming.AvoidCaps, accept_atoms: [:String.downcase]
defmodule Green.Rules.Linting.PreferPipelinesTest do
  use Green.TestCase, async: true

  alias Green.Rules.Linting.PreferPipelines

  @tag example: "linting/prefer_pipelines_bad"
  @tag fixture_pair: "linting/prefer_pipelines"
  test "transforms triply-nested function calls into pipelines", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag example: "linting/prefer_pipelines_bad"
  @tag fixture_pair: "linting/prefer_pipelines"
  test "supports configuration of functions to ignore", %{
    forms: forms,
    comments: comments,
    bad: bad
  } do
    {forms, comments} =
      PreferPipelines.apply({forms, comments},
        green: [prefer_pipelines: [ignore_functions: ["String.downcase": 1]]]
      )

    output = default_format({forms, comments})
    assert output == bad
  end

  @tag example: "linting/prefer_pipelines/ignore_map_access"
  test "does not consider Map access as a function call", %{
    forms: forms,
    comments: comments,
    example: example
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end

  @tag example: "linting/prefer_pipelines/try_rescue"
  test "does not consider try as a function call", %{
    forms: forms,
    comments: comments,
    example: example
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end

  @tag example: "linting/prefer_pipelines/nested_second_parameter_bad"
  @tag fixture_pair: "linting/prefer_pipelines/nested_second_parameter"
  test "only transforms the first parameter of a nested function call", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag example: "linting/prefer_pipelines/keyword_arguments_bad"
  @tag fixture_pair: "linting/prefer_pipelines/keyword_arguments"
  test "wraps keyword aguments in square brackets", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag example: "linting/prefer_pipelines/record_usage"
  test "does not consider record use as a function call", %{
    forms: forms,
    comments: comments,
    example: example
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end

  @tag example: "linting/prefer_pipelines/skip_quotes"
  test "ignores quote blocks", %{forms: forms, comments: comments, example: example} do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end

  @tag example: "linting/prefer_pipelines/skip_operators"
  test "ignores operators", %{forms: forms, comments: comments, example: example} do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end

  @tag example: "linting/prefer_pipelines/__module___bad"
  @tag fixture_pair: "linting/prefer_pipelines/__module__"
  test "handles __MODULE__.function", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  describe "except configuration" do
    test "skips transformation when entire file is in except list" do
      code = """
      String.reverse(String.upcase(String.downcase("hello")))
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        PreferPipelines.apply({forms, comments},
          green: [prefer_pipelines: [except: ["test/example.exs"]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when file is in except list
      assert output == code
    end

    test "skips transformation for specific line when in except list" do
      code = """
      String.reverse(String.upcase(String.downcase("hello")))
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        PreferPipelines.apply({forms, comments},
          green: [prefer_pipelines: [except: [{"test/example.exs", 1}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when line is in except list
      assert output == code
    end

    test "skips transformation for multiple lines when in except list" do
      code = """
      String.reverse(String.upcase(String.downcase("hello")))

      String.reverse(String.upcase(String.downcase("world")))
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        PreferPipelines.apply({forms, comments},
          green: [prefer_pipelines: [except: [{"test/example.exs", [1, 3]}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should not transform when lines are in except list
      assert output == code
    end

    test "transforms lines not in except list" do
      code = """
      String.reverse(String.upcase(String.downcase("hello")))

      String.reverse(String.upcase(String.downcase("world")))
      """

      expected = """
      String.reverse(String.upcase(String.downcase("hello")))

      "world" |> String.downcase() |> String.upcase() |> String.reverse()
      """

      {forms, comments} = parse_code(code)

      {forms, comments} =
        PreferPipelines.apply({forms, comments},
          green: [prefer_pipelines: [except: [{"test/example.exs", 1}]]],
          file: Path.expand("test/example.exs")
        )

      output = default_format({forms, comments})

      # Should only transform line 3, not line 1
      assert output == expected
    end
  end
end
