defmodule PatternMatchBinary do
  def parameter_match_with_string(<<"prefix", rest::bytes>>) do
    rest
  end

  def parameter_match_with_type(<<first::utf8, rest::bytes>>) do
    {first, rest}
  end

  def equals_match(text) do
    <<"prefix", rest::bytes>> = text
    rest
  end
end
