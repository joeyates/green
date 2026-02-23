defmodule Green.Rules.Exceptions.LowercaseExceptionMessages do
  @moduledoc """
  Warns when exception messages are capitalized.
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
          if String.match?(message, ~r/^[A-Z]/) do
            IO.warn(
              """
              exception message should be lowercase
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