defmodule Green.Options do
  @moduledoc false

  def set_value(opts, path, value) do
    put_in_autovivify(opts, [:green | path], value)
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
end
