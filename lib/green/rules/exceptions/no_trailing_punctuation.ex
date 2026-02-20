defmodule Green.Rules.Exceptions.NoTrailingPunctuationInExceptionMessages do
  @moduledoc """
  Warns when exception messages have trailing punctuation.
  """

  alias Green.Rule

  @behaviour Rule

  @impl Rule
  def apply({forms, comments}, opts) do
    Macro.prewalk(
      forms,
      fn
        {
          :raise,
          context,
          [
            {:__aliases__, _ctx2, _error_module},
            {:__block__, _ctx3, [message]}
          ]
        } = node
        when is_binary(message) ->
          if String.match?(message, ~r/[[:punct:]]$/) do
            IO.warn(
              """
              exception message should not have trailing punctuation
              #{context[:line]} | #{Macro.to_string(node)}
              """,
              opts
            )
          end

        other ->
          other
      end
    )

    {forms, comments}
  end
end