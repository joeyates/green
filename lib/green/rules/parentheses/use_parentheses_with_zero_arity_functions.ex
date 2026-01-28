defmodule Green.Rules.Parentheses.UseParenthesesWithZeroArityFunctions do
  @moduledoc """
  This module adds parentheses to zero-arity function and macro definitions.
  """

  @behaviour Green.Rule

  @definition_keywords [:def, :defp, :defmacro, :defmacrop]

  @impl true
  def apply({forms, comments}, _opts) do
    forms =
      Macro.prewalk(forms, fn
        # The `nil`, and the lack of a `:closing` value means no parameters
        {keyword, context, [{name, head_context, nil} | rest] = right}
        when keyword in @definition_keywords ->
          right =
            if head_context[:closing] do
              right
            else
              line = Keyword.fetch!(head_context, :line)
              head_context = Keyword.put(head_context, :closing, line: line)
              [{name, head_context, []} | rest]
            end

          {keyword, context, right}

        other ->
          other
      end)

    {forms, comments}
  end
end
