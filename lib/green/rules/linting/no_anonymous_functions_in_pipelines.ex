defmodule Green.Rules.Linting.NoAnonymousFunctionsInPipelines do
  @moduledoc """
  This rule checks for anonymous functions in pipelines and prints a warning.

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  ```elixir
    green: [
      no_anonymous_functions_in_pipelines: [
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

  @behaviour Green.Rule
  @rule_name :no_anonymous_functions_in_pipelines

  alias Green.Options

  @impl true
  def apply(parsed, opts) do
    opts = prepare_opts(opts)
    rule_opts = get_in(opts, [:green, @rule_name]) || []
    if rule_opts[:enabled] do
      do_apply(parsed, rule_opts, opts)
    else
      parsed
    end
  end

  defp do_apply({forms, _comments} = parsed, rule_opts, opts) do
    except_lines = rule_opts[:except_lines] || []
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
          if context[:line] in except_lines do
            node
          else
            IO.warn(
              """
              anonymous function found in pipeline (consider defining a named function instead)
              #{context[:line]} | #{Macro.to_string(fun)}
              """,
              opts
            )

            node
          end

        other ->
          other
      end
    )

    parsed
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
