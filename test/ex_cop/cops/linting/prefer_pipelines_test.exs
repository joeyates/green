defmodule ExCop.Cops.Linting.PreferPipelinesTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Linting.PreferPipelines

  @tag parse: "linting/prefer_pipelines/ignore_map_access"
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

  @tag parse: "linting/prefer_pipelines/nested_second_parameter_bad"
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

  @tag parse: "linting/prefer_pipelines/record_usage"
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
end
