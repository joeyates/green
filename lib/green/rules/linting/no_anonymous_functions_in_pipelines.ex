defmodule Green.Rules.Linting.NoAnonymousFunctionsInPipelines do
  @moduledoc """
  This rule checks for anonymous functions in pipelines and prints a warning.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  In `.formatter.exs`:

  ```elixir
    green: [
      no_anonymous_functions_in_pipelines: [
        enabled: *true | false
      ]
    ]
  ```
  """

  @behaviour Green.Rule

  alias Green.Options

  @impl true
  def apply(parsed, opts) do
    opts = prepare_opts(opts)
    enabled = opts[:green][:no_anonymous_functions_in_pipelines][:enabled]
    do_apply(parsed, enabled, opts)
  end

  defp do_apply(parsed, falsey, _opts) when not falsey, do: parsed

  defp do_apply({forms, _comments} = parsed, _truthy, opts) do
    Macro.prewalk(
      forms,
      fn
        {
          # Pipeline operator
          :|>,
          _ctx1,
          [
            _first
            | [
                {
                  {
                    # Anonymous function application
                    :.,
                    _ctx2,
                    [
                      # Anonymous function
                      {:fn, context, _body}
                    ]
                  },
                  _ctx3,
                  _args
                } = fun
              ]
          ]
        } = node ->
          IO.warn(
            """
            anonymous function found in pipeline (consider defining a named function instead)
            #{context[:line]} | #{Macro.to_string(fun)}
            """,
            opts
          )

          node

        other ->
          other
      end
    )

    parsed
  end

  defp prepare_opts(opts) do
    Options.set_value(
      opts,
      [:no_anonymous_functions_in_pipelines],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
  end
end
