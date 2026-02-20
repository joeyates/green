defmodule PredicateFunsName do
  # Bad: predicate function without ? suffix
  def is_even(number) do
    rem(number, 2) == 0
  end

  # Bad: using has_ prefix
  def has_permission(user) do
    user.role == :admin
  end

  defmacro valid?(value) do
    quote do
      value in [1, 2, 3]
    end
  end
end
