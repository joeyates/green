defmodule Green.Rules.Exceptions.NoTrailingPunctuationInExceptionMessages do
  @moduledoc """
  Warns when exception messages have trailing punctuation.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      no_trailing_punctuation_in_exception_messages: [
        enabled: *true | false,
        except: [
          "path/to/file.exs",
          {"path/to/other_file.exs", 42},
          {"path/to/yet_another_file.exs", [10, 20, 30]}
        ]
      ]
    ]
  ```
  """

  alias Green.Rule
  alias Green.Options

  @behaviour Rule
  @rule_name :no_trailing_punctuation_in_exception_messages

  @impl Rule
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = get_in(opts, [:green, @rule_name, :enabled])

    if enabled do
      do_apply({forms, comments}, opts)
    end

    {forms, comments}
  end

  defp do_apply({forms, _comments}, opts) do
    except_lines = get_in(opts, [:green, @rule_name, :except_lines]) || []

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
          if String.match?(message, ~r/[[:punct:]]$/) and context[:line] not in except_lines do
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
  end

  defp prepare_opts(opts) do
    opts
    |> Options.set_value(
      [@rule_name],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end
end
