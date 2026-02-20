defmodule ElixirFormatterTest do
  use ExUnit.Case
  doctest ElixirFormatter

  test "greets the world" do
    assert ElixirFormatter.hello() == :world
  end
end
