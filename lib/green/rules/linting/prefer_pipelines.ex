defmodule Green.Rules.Linting.PreferPipelines do
  @moduledoc """
  This rule transforms nested function calls into pipelines.
  """

  alias Green.Function.Signature

  @behaviour Green.Rule

  @impl true
  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)

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
            acc = update_in(acc, [:records], fn records -> [to_string(name) | records] end)
            {node, acc}

          # Handle existing pipelines
          {:|>, context, [first | rest]}, acc ->
            parameters =
              if pipelinable?(first, opts, acc) do
                # We're in a pipeline, but the first parameter is a normal function call
                [to_pipeline(first) | rest]
              else
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
                 true <- pipelinable?(node, opts, acc),
                 {:ok, first} <- first_argument(node),
                 true <- pipelinable?(first, opts, acc) do
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

  defp prepare_opts(opts) do
    opts
    |> update_in([:green], &(&1 || []))
    |> update_in([:green, :prefer_pipelines], &(&1 || []))
    |> update_in(
      [:green, :prefer_pipelines, :ignore_functions],
      fn
        nil ->
          []

        list ->
          Enum.map(list, &build_function/1)
      end
    )
  end

  defp build_function({modules_and_name, arity}) when is_atom(modules_and_name) do
    build_function({to_string(modules_and_name), arity})
  end

  defp build_function({modules_and_name, arity})
       when is_binary(modules_and_name) and is_integer(arity) do
    [name | modules] = modules_and_name |> String.split(".") |> Enum.reverse()
    modules |> Enum.reverse() |> Signature.new(name, arity)
  end

  defp pipelinable?({:|>, _ctx, _right}, _opts, _acc), do: false

  defp pipelinable?(node, opts, acc) do
    with {:ok, function} <- function(node),
         arity when arity > 0 <- function.arity,
         true <- requires_parens?(function, opts[:locals_without_parens]),
         false <- ignore?(function, opts[:green][:prefer_pipelines][:ignore_functions]),
         false <- function.name in acc[:records] do
      true
    else
      _ ->
        false
    end
  end

  @syntax ~w(
    def defp defmodule defmacro defmacrop defstruct defdelegate
    if unless for case cond try with when and not or in
    fn use alias import require raise reraise
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

  defp ignore?(function, ignore_functions) do
    Enum.any?(ignore_functions, &(&1 == function))
  end

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
