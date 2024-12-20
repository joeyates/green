defmodule PatternMatchBinary do
  def parameter_match_with_string("prefix" <> rest) do
    rest
  end

  def parameter_match_with_type(<<first::utf8>> <> rest) do
    {first, rest}
  end

  def equals_match(text) do
    "prefix" <> rest = text
    rest
  end
end
