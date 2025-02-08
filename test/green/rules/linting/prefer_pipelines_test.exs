defmodule Green.Rules.Linting.PreferPipelinesTest do
  use Green.TestCase, async: true

  alias Green.Rules.Linting.PreferPipelines

  @tag example: "linting/favor_pipeline_operator_bad"
  @tag fixture_pair: "linting/favor_pipeline_operator"
  test "transforms triply-nested function calls into pipelines", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag example: "linting/favor_pipeline_operator_bad"
  @tag fixture_pair: "linting/favor_pipeline_operator"
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
end
