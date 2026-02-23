defmodule ExceptionMessage do
  def bad_error_message() do
    # Bad: capitalized message
    raise RuntimeError, "Invalid input"
  end

  def trailing_punctuation() do
    # Bad: trailing punctuation
    raise ArgumentError, "invalid argument!"
  end
end
