defmodule Green.Rules.Parentheses.UseParenthesesWithZeroArityFunctions do
  @moduledoc """
  This module adds parentheses to zero-arity function and macro definitions.
  """

  @behaviour Green.Rule

  alias Green.Options

  @definition_keywords [:def, :defp, :defmacro, :defmacrop]

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:use_parentheses_with_zero_arity_functions][:enabled]
    do_apply({forms, comments}, enabled)
  end

  defp do_apply({forms, comments}, falsey) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy) do
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

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:use_parentheses_with_zero_arity_functions],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end
end
