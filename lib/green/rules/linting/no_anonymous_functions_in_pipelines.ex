defmodule Green.Rules.Linting.NoAnonymousFunctionsInPipelines do
  @moduledoc """
  This rule checks for anonymous functions in pipelines and prints a warning.
  """

  @behaviour Green.Rule

  @impl true
  def apply({forms, _comments} = parsed, opts) do
    Macro.prewalk(
      forms,
      fn
        {
          # Pipeline operator
          :|>,
          _ctx1,
          [
            _first |
            [
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
end
