defmodule SkipOperators do
  import Bitwise

  def ororor(crc, byte) do
    bxor(crc, byte) ||| 0xFF
  end

  def andandand(crc, byte) do
    bxor(crc, byte) &&& 0xFF
  end
end
