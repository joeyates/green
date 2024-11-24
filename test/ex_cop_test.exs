defmodule ExCopTest do
  use ExUnit.Case, async: true

  @bad_files Path.wildcard("test/fixtures/*-bad.ex*")

  for bad <- @bad_files do
    test "format #{bad}" do
      bad = unquote(bad)
      good = String.replace(bad, "-bad.ex", "-good.ex")

      formatted = ExCop.format_file(bad)
      expected = File.read!(good)

      assert formatted == expected
    end
  end
end
