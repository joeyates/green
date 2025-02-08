defmodule Green.Rules.Exceptions.UseErrorSuffixTest do
  use Green.TestCase, async: true

  alias Green.Rules.Exceptions.UseErrorSuffix

  @tag example: "exceptions/use_error_suffix/namespaced_error"
  test "handles namespaced error modules", %{forms: forms, comments: comments, example: example} do
    {forms, comments} = UseErrorSuffix.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == example
  end
end
