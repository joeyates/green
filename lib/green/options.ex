defmodule Green.Options do
  @moduledoc false

  def set_value(opts, path, value) do
    put_in_autovivify(opts, [:green | path], value)
  end

  def set_default(opts, path, default) do
    put_in_autovivify(opts, [:green | path], fn current ->
      if current == nil do
        default
      else
        current
      end
    end)
  end

  defp put_in_autovivify(list, _keys, _value) when not is_list(list),
    do: raise(ArgumentError, "Expected a list, got: #{inspect(list)}")

  defp put_in_autovivify(list, [], _value), do: list

  defp put_in_autovivify(list, [key], fun) when is_function(fun) do
    updated = fun.(list[key])
    Keyword.put(list, key, updated)
  end

  defp put_in_autovivify(list, [key], value) do
    Keyword.put(list, key, value)
  end

  defp put_in_autovivify(list, [first | rest], value) do
    current = list[first] || []
    nested = put_in_autovivify(current, rest, value)
    Keyword.put(list, first, nested)
  end

  def prepare_except(opts, rule) do
    {except, opts} = pop_in(opts, [:green, rule, :except])
    do_prepare_except(opts, rule, except)
  end

  defp do_prepare_except(opts, _rule, nil), do: opts

  defp do_prepare_except(opts, rule, except) when is_list(except) do
    file_to_format = Keyword.fetch!(opts, :file)

    {disable_file, except_lines} =
      Enum.reduce(
        except,
        {false, []},
        fn
          {except_file, lines}, {acc_file, acc_lines} when is_list(lines) ->
            absolute = Path.expand(except_file)

            if absolute == file_to_format do
              {acc_file, lines ++ acc_lines}
            else
              {acc_file, acc_lines}
            end

          {except_file, line}, {acc_file, acc_lines} when is_integer(line) ->
            absolute = Path.expand(except_file)

            if absolute == file_to_format do
              {acc_file, [line | acc_lines]}
            else
              {acc_file, acc_lines}
            end

          except_file, {acc_file, acc_lines} ->
            absolute = Path.expand(except_file)

            if absolute == file_to_format do
              {true, acc_lines}
            else
              {acc_file, acc_lines}
            end
        end
      )

    if disable_file do
      set_value(opts, [rule, :enabled], false)
    else
      set_value(opts, [rule, :except_lines], except_lines)
    end
  end
end
