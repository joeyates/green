defmodule ExCop.Cops.Exceptions.UseErrorSuffixTest do
  use ExCop.TestCase, async: true

  alias ExCop.Cops.Exceptions.UseErrorSuffix

  @tag parse: "exceptions/use_error_suffix/namespaced_error"
  @tag example: "exceptions/use_error_suffix/namespaced_error"
  test "handles namespaced error modules", %{forms: forms, comments: comments, example: example} do
    {forms, comments} = UseErrorSuffix.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end
end
