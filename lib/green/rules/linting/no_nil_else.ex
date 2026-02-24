defmodule Green.Rules.Linting.NoNilElse do
  @moduledoc """
  This module removes `else` clauses that return `nil`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      no_nil_else: [
        enabled: *true | false
      ]
    ]
  ```
  """

  @behaviour Green.Rule

  alias Green.Options

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:no_nil_else][:enabled]
    do_apply({forms, comments}, enabled)
  end

  defp do_apply({forms, comments}, falsey) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy) do
    forms =
      Macro.prewalk(forms, fn
        {:if, context,
         [
           condition,
           [
             {{:__block__, ctx1, [:do]}, do_expression},
             {{:__block__, _ctx2, [:else]}, {:__block__, _ctx, [nil]}}
           ]
         ]} ->
          {:if, context,
           [
             condition,
             [
               {{:__block__, ctx1, [:do]}, do_expression}
             ]
           ]}

        other ->
          other
      end)

    {forms, comments}
  end

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:no_nil_else],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end
end
