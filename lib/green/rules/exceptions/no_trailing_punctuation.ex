defmodule Green.Rules.Exceptions.NoTrailingPunctuationInExceptionMessages do
  @moduledoc """
  Warns when exception messages have trailing punctuation.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      no_trailing_punctuation_in_exception_messages: [
        enabled: *true | false
      ]
    ]
  ```
  """

  alias Green.Rule
  alias Green.Options

  @behaviour Rule

  @impl Rule
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:no_trailing_punctuation_in_exception_messages][:enabled]
    do_apply({forms, comments}, enabled, opts)
  end

  defp do_apply({forms, comments}, falsey, _opts) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy, opts) do
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

          node

        other ->
          other
      end
    )

    {forms, comments}
  end

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:no_trailing_punctuation_in_exception_messages],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end
end
