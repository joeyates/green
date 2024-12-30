defmodule ExCop.Cops.Linting.PreferPipelinesTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Linting.PreferPipelines

  @tag parse: "linting/ignore_map_access"
  @tag example: "linting/ignore_map_access"
  test "does not consider Map access as a function call", %{
    forms: forms,
    comments: comments,
    example: example
  } do
    {forms, comments} = PreferPipelines.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end
end
