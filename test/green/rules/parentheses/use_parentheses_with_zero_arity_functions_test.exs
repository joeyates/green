defmodule Green.Rules.Parentheses.UseParenthesesWithZeroArityFunctionsTest do
  use Green.TestCase, async: true

  alias Green.Rules.Parentheses.UseParenthesesWithZeroArityFunctions

  @tag example: "parentheses/use_parentheses_with_zero_arity_functions_bad"
  @tag fixture_pair: "parentheses/use_parentheses_with_zero_arity_functions"
  test "adds parentheses to zero-arity function definitions", %{
    forms: forms,
    comments: comments,
    good: good
  } do
    {forms, comments} = UseParenthesesWithZeroArityFunctions.apply({forms, comments}, [])
    output = default_format({forms, comments})
    assert output == good
  end

  @tag example: "parentheses/use_parentheses_with_zero_arity_functions_bad"
  @tag fixture_pair: "parentheses/use_parentheses_with_zero_arity_functions"
  test "supports configuration to disable the rule", %{
    forms: forms,
    comments: comments,
    bad: unchanged
  } do
    {forms, comments} =
      UseParenthesesWithZeroArityFunctions.apply({forms, comments},
        green: [use_parentheses_with_zero_arity_functions: [enabled: false]]
      )

    output = default_format({forms, comments})
    assert output == unchanged
  end
end
