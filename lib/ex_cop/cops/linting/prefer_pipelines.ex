defmodule ExCop.Cops.Linting.PreferPipelines do
  @moduledoc """
  This cop transforms nested function calls into pipelines.
  """

  alias ExCop.Function.Signature

  @behaviour ExCop.Cop

  @impl true
  def apply({forms, comments}, opts) do
    {forms, _acc} =
      Macro.traverse(
        forms,
        %{records: []},
        fn
          {:@, _ctx1, [{:spec, _ctx2, _right}]} = node, acc ->
            {node, Map.put(acc, :in_spec, true)}

          node, %{in_spec: true} = acc ->
            {node, acc}

          {:@, _ctx1, [{:type, _ctx2, _right}]} = node, acc ->
            {node, Map.put(acc, :in_type, true)}

          node, %{in_type: true} = acc ->
            {node, acc}

          {:quote, _context, _right} = node, acc ->
            {node, Map.put(acc, :in_quote, true)}

          node, %{in_quote: true} = acc ->
            {node, acc}

          # attribute definitions look like function calls - ignore them
          {:@, ctx1, [{attribute, ctx2, right}]}, acc ->
            ctx2 = Keyword.put(ctx2, :attribute, true)
            {{:@, ctx1, [{attribute, ctx2, right}]}, acc}

          {call, ctx1, [{name, ctx2, parameters} | rest]}, acc when call in [:def, :defp] ->
            ctx2 = Keyword.put(ctx2, :function, true)
            {{call, ctx1, [{name, ctx2, parameters} | rest]}, acc}

          {:@, _context, _right} = node, acc ->
            {node, acc}

          {{:., _ctx1, [{:__aliases__, _ctx2, [:Record]}, call]}, _ctx3,
           [
             {:__block__, _ctx4, [name]},
             _fields
           ]} = node,
          acc
          when call in [:defrecord, :defrecordp] ->
            acc = update_in(acc, [:records], fn records -> [name | records] end)
            {node, acc}

          # Handle existing pipelines
          {:|>, context, [first | rest]}, acc ->
            parameters =
              with {:ok, function} <- function(first),
                   arity when arity > 0 <- function.arity,
                   true <- requires_parens?(function, opts[:locals_without_parens]) do
                # We're in a pipeline, but the first parameter is a normal function call
                [to_pipeline(first) | rest]
              else
                _ ->
                  [first | rest]
              end

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
                 nil <- context[:function],
                 nil <- context[:pipeline_parameter],
                 {:ok, function} <- function(node),
                 arity when arity > 0 <- function.arity,
                 true <- requires_parens?(function, opts[:locals_without_parens]),
                 {:ok, first} <- first_argument(node),
                 true <- pipelinable?(first, acc[:records]) do
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

          {:quote, _context, _right} = node, acc ->
            {node, Map.delete(acc, :in_quote)}

          {:@, ctx1, [{attribute, ctx2, right}]}, acc ->
            ctx2 = Keyword.delete(ctx2, :attribute)
            {{:@, ctx1, [{attribute, ctx2, right}]}, acc}

          {call, ctx1, [{name, ctx2, parameters} | rest]}, acc when call in [:def, :defp] ->
            ctx2 = Keyword.delete(ctx2, :function)
            {{call, ctx1, [{name, ctx2, parameters} | rest]}, acc}

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

  defp pipelinable?({:|>, _ctx, _right}, _records), do: true

  defp pipelinable?(node, records) do
    with {:ok, function} <- function(node),
         arity when arity > 0 <- function.arity,
         false <- function.name in records do
      true
    else
      _ ->
        false
    end
  end

  @syntax ~w(
    def defp defmodule defmacro defmacrop defstruct defdelegate
    if unless for case cond with when and not or in
    fn use alias import require reraise
    quote unquote
    __block__
    __aliases__
    :: \\\\ / ! & @ || &&
    <- -> <> | |> <<>> |||
    = == != === !== =~ > < >= <=
    {} %{} %
    + ++ - -- * ^ <<< >>> .. ..//
  )a

  defp function({left, _context, _right}) when left in @syntax, do: nil

  defp function({{:., _ctx1, [{:__aliases__, _ctx2, modules}, name]}, _ctx3, arguments}) do
    {:ok, Signature.new(modules, name, length(arguments))}
  end

  # Erlang function invocation
  defp function({{:., _ctx1, [{:__block__, _ctx2, [module]}, name]}, _ctx3, arguments}) do
    {:ok, Signature.new([module], name, length(arguments))}
  end

  defp function({:., _context, _right}), do: nil

  defp function({left, context, arguments}) when is_atom(left) and is_list(arguments) do
    if context[:delimiter] do
      # Exclude sigils
      nil
    else
      # Local or imported function invocation
      {:ok, Signature.new([], left, length(arguments))}
    end
  end

  defp function(_other), do: nil

  defp first_argument({_left, _context, [first | _rest]}), do: {:ok, first}

  defp first_argument(_other), do: nil

  defp requires_parens?({_name, _arity}, nil), do: true

  defp requires_parens?({name, arity}, locals_without_parens)
       when is_atom(name) and is_integer(arity) do
    {name, arity} not in locals_without_parens
  end

  defp requires_parens?(%Signature{modules: []} = function, locals_without_parens) do
    requires_parens?({function.name, function.arity}, locals_without_parens)
  end

  defp requires_parens?(_function, _locals_without_parens), do: true

  defp to_pipeline(node) do
    case function(node) do
      {:ok, %Signature{arity: 0}} ->
        node

      {:ok, _function} ->
        {left, context, [first | rest]} = node
        # Change keyword arguments to a proper Keyword, wrapped in `[]`
        first = wrap_bare_keyword(first)
        # TODO: adjust context, e.g. the value of `:closing`
        second_context = Keyword.put(context, :pipeline_parameter, true)
        {:|>, context, [to_pipeline(first), {left, second_context, rest}]}

      _ ->
        node
    end
  end

  defp wrap_bare_keyword([first | _rest] = term) do
    if Enum.all?(term, &keyword_value?/1) do
      # Re-use the context of the first keyword
      {{:__block__, ctx1, [_name]}, {:__block__, _ctx2, [_value]}} = first
      # TODO: adjust context, e.g. the value of `:closing`
      [{:__block__, ctx1, [term]}]
    else
      term
    end
  end

  defp wrap_bare_keyword(term), do: term

  defp keyword_value?({{:__block__, ctx1, [_name]}, {:__block__, _ctx2, [_value]}}) do
    ctx1[:format] == :keyword
  end

  defp keyword_value?(_term), do: false
end
