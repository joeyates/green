defmodule Green.Rules.Linting.NoUnlessWithElse do
  @moduledoc """
  This rule transforms `unless` with `else` into `if` with `else`.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      no_unless_with_else: [
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
    enabled = opts[:green][:no_unless_with_else][:enabled]
    do_apply({forms, comments}, enabled)
  end

  defp do_apply({forms, comments}, falsey) when not falsey, do: {forms, comments}

  defp do_apply({forms, comments}, _truthy) do
    forms =
      Macro.prewalk(forms, fn
        {:unless, context,
         [
           condition,
           [
             {{:__block__, ctx1, [:do]}, do_expression},
             {{:__block__, ctx2, [:else]}, else_expression}
           ]
         ]} ->
          {:if, context,
           [
             condition,
             [
               {{:__block__, ctx1, [:do]}, else_expression},
               {{:__block__, ctx2, [:else]}, do_expression}
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
      [:no_unless_with_else],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end
end
