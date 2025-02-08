defmodule Green.Quoted do
  @moduledoc """
  Conveniences for modifying the AST and associated comments.
  """

  def new_position(current, from, from), do: current

  def new_position(current, from, to) when from > to do
    cond do
      current < to -> current
      current > from -> current
      current == from -> to
      true -> current + 1
    end
  end

  def new_position(current, from, to) do
    cond do
      current < from -> current
      current > to -> current
      current == from -> to
      true -> current - 1
    end
  end

  def shift(context, path, from, to) do
    case get_in(context, path) do
      nil ->
        context

      line ->
        moved = new_position(line, from, to)
        put_in(context, path, moved)
    end
  end
end
