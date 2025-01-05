defmodule ExCop.Cops.Linting.PreferPipelines do
  @moduledoc """
  This cop transforms nested function calls into pipelines.
  """

  @behaviour ExCop.Cop

  @impl true
  def apply({forms, comments}, opts) do
    {forms, _acc} =
      Macro.traverse(
        forms,
        %{},
        fn
          {:@, _ctx1, [{:spec, _ctx2, _right}]} = node, acc ->
            {node, Map.put(acc, :in_spec, true)}

          node, %{in_spec: true} = acc ->
            {node, acc}

          {:@, _ctx1, [{:type, _ctx2, _right}]} = node, acc ->
            {node, Map.put(acc, :in_type, true)}

          node, %{in_type: true} = acc ->
            {node, acc}

          # attribute definitions look like function calls - ignore them
          {:@, ctx1, [{attribute, ctx2, right}]}, acc ->
            ctx2 = Keyword.put(ctx2, :attribute, true)
            {{:@, ctx1, [{attribute, ctx2, right}]}, acc}

          {:@, _context, _right} = node, acc ->
            {node, acc}

          # Ignore existing pipelines
          {:|>, context, parameters}, acc ->
            parameters =
              Enum.map(parameters, fn
                {left, context, right} ->
                  # Don't transform pipeline parameters into pipelines
                  {left, Keyword.put(context, :pipeline_parameter, true), right}

                node ->
                  node
              end)

            {{:|>, context, parameters}, acc}

          {_left, context, _right} = node, acc ->
            with nil <- context[:attribute],
                 nil <- context[:pipeline_parameter],
                 {:ok, {function, arity}} when arity > 0 <- function(node),
                 true <- requires_parens?({function, arity}, opts[:locals_without_parens]),
                 {:ok, first} <- first_argument(node),
                 {:ok, {_child_function, child_arity}} when child_arity > 0 <- function(first) do
              {to_pipeline(node), acc}
            else
              _ ->
                {node, acc}
            end

          node, acc ->
            {node, acc}
        end,
        fn
          {:@, _ctx1, [{:spec, _ctx2, _right}]} = node, acc ->
            {node, Map.delete(acc, :in_spec)}

          {:@, _ctx1, [{:type, _ctx2, _right}]} = node, acc ->
            {node, Map.delete(acc, :in_type)}

          {:@, ctx1, [{attribute, ctx2, right}]}, acc ->
            ctx2 = Keyword.delete(ctx2, :attribute)
            {{:@, ctx1, [{attribute, ctx2, right}]}, acc}

          {:|>, context, parameters}, acc ->
            parameters =
              Enum.map(parameters, fn
                {left, context, right} ->
                  {left, Keyword.delete(context, :pipeline_parameter), right}

                node ->
                  node
              end)

            {{:|>, context, parameters}, acc}

          node, acc ->
            {node, acc}
        end
      )

    {forms, comments}
  end

  @syntax ~w(
    def defp defmodule defmacro defstruct defdelegate
    if case when and not or in
    fn use alias import require
    unquote
    __block__
    __aliases__
    :: \\\\ / & @ || &&
    <- -> <> | |> <<>>
    = == != =~ > < >= <=
    {} %{} %
    + ++ - * ^ ..
  )a

  defp function({left, _context, _right}) when left in @syntax, do: nil

  defp function(
         {{:., _ctx1, [{:__aliases__, _ctx2, _modules}, _name]} = function, _ctx3, arguments}
       ) do
    {:ok, {function, length(arguments)}}
  end

  # Erlang function invocation
  defp function(
         {{:., _ctx1, [{:__block__, _ctx2, [_module]}, _name]} = function, _ctx3, arguments}
       ) do
    {:ok, {function, length(arguments)}}
  end

  defp function({:., _context, _right}), do: nil

  defp function({left, context, arguments}) when is_atom(left) and is_list(arguments) do
    if context[:delimiter] do
      # Exclude sigils
      nil
    else
      # Local or imported function invocation
      {:ok, {left, length(arguments)}}
    end
  end

  defp function(_other), do: nil

  defp first_argument({_left, _context, [first | _rest]}), do: {:ok, first}

  defp first_argument(_other), do: nil

  defp requires_parens?({function, arity}, locals_without_parens)
       when is_atom(function) and is_list(locals_without_parens) do
    {function, arity} not in locals_without_parens
  end

  defp requires_parens?(_fn_arity, _locals_without_parens), do: true

  defp to_pipeline(node) do
    case function(node) do
      {:ok, {_function, 0}} ->
        node

      {:ok, {_function, _arity}} ->
        {left, context, [first | rest]} = node
        # TODO: Create proper contexts
        {:|>, context, [to_pipeline(first), {left, context, rest}]}

      _ ->
        node
    end
  end
end
