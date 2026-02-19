defmodule Green.OptionsTest do
  use ExUnit.Case, async: true

  describe "set_value/3" do
    test "puts value at the given path, autovivifying intermediate lists" do
      updated_opts = Green.Options.set_value([], [:a, :b, :c], 42)

      assert updated_opts == [green: [a: [b: [c: 42]]]]
    end

    test "puts value returned by function at the given path, autovivifying intermediate lists" do
      updated_opts =
        Green.Options.set_value([], [:x, :y], fn current -> (current || []) ++ [99] end)

      assert updated_opts == [green: [x: [y: [99]]]]
    end

    test "raises if the initial opts is not a list" do
      assert_raise ArgumentError, ~r/Expected a list/, fn ->
        Green.Options.set_value(%{}, [:a], 1)
      end
    end
  end
end
