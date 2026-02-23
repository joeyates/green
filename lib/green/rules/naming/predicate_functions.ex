defmodule Green.Rules.Naming.PredicateFunctions do
  @moduledoc false

  alias Green.Rule

  @behaviour Rule

  @function_definition_keywords [:def, :defp]
  @macro_definition_keywords [:defmacro, :defmacrop]

  @impl Rule
  def apply({forms, comments}, opts) do
    Macro.prewalk(
      forms,
      fn
        {keyword, context, [{name, _, _} = left | _]} = node
        when keyword in @function_definition_keywords ->
          if guard_style?(name) do
            IO.warn(
              """
              predicate function should have `?` suffix
              #{context[:line]} | #{keyword} #{Macro.to_string(left)} do
              """,
              opts
            )
          end

          node

        {keyword, context, [{name, _, _} = left | _]} = node
        when keyword in @macro_definition_keywords ->
          if final_question_mark?(name) do
            IO.warn(
              """
              guard-style macros should not have `?` suffix, use `is_` prefix instead
              #{context[:line]} | #{keyword} #{Macro.to_string(left)} do
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

  defp guard_style?(name) do
    name
    |> to_string()
    |> String.starts_with?("is_")
  end

  defp final_question_mark?(name) do
    name
    |> to_string()
    |> String.ends_with?("?")
  end
end