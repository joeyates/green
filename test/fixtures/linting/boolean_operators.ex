defmodule BooleanOperators do
  # Section: BOOL OPERATOR BOOL
  def bad_boolean_value_with_boolean_value() do
    true && false
  end

  def good_boolean_value_with_boolean_value() do
    true and false
  end

  def bad_boolean_value_with_guard_style(name) do
    false || is_atom(name)
  end

  def good_boolean_value_with_guard_style(name) do
    false or is_atom(name)
  end

  def bad_boolean_value_with_predicate(name) do
    false && really?(name)
  end

  def good_boolean_value_with_predicate(name) do
    false and really?(name)
  end

  def bad_boolean_value_with_comparison(name) do
    false || name == :foo
  end

  def good_boolean_value_with_comparison(name) do
    false or name == :foo
  end

  def bad_guard_style_with_boolean_value(name) do
    is_atom(name) && true
  end

  def good_guard_style_with_boolean_value(name) do
    is_atom(name) and true
  end

  def bad_guard_style_with_predicate(name) do
    is_atom(name) || really?(name)
  end

  def good_guard_style_with_predicate(name) do
    is_atom(name) or really?(name)
  end

  def bad_guard_style_with_comparison(name) do
    is_atom(name) && name != nil
  end

  def good_guard_style_with_comparison(name) do
    is_atom(name) and name != nil
  end

  def bad_predicate_with_boolean_value(name) do
    really?(name) || true
  end

  def good_predicate_with_boolean_value(name) do
    really?(name) or true
  end

  def bad_predicate_with_guard_style(name) do
    really?(name) && is_atom(name)
  end

  def good_predicate_with_guard_style(name) do
    really?(name) and is_atom(name)
  end

  def bad_predicate_with_comparison(name) do
    really?(name) || name != nil
  end

  def good_predicate_with_comparison(name) do
    really?(name) or name != nil
  end

  # Section: OTHER OPERATOR ANYTHING -> Good

  def good_value_first() do
    1 && true
  end

  def good_local_non_boolean_function_call_first(name) do
    title(name) || false
  end

  def good_module_function_call_first(baz) do
    Foo.bar(baz) && correct?(baz)
  end

  # Section: ANYTHING OPERATOR OTHER -> Good

  def good_value_second() do
    true && 1
  end

  def good_local_non_boolean_function_call_second(name) do
    false || title(name)
  end

  def good_module_function_call_second(baz) do
    correct?(baz) && Foo.bar(baz)
  end

  # Section: BANG BOOLEAN -> Bad

  def bad_bang_boolean_value() do
    !true
  end

  def good_not_boolean_value() do
    not true
  end

  def bad_bang_guard_style(name) do
    !is_atom(name)
  end

  def good_not_guard_style(name) do
    not is_atom(name)
  end

  def bad_bang_predicate(name) do
    !really?(name)
  end

  def good_not_predicate(name) do
    not really?(name)
  end

  def bad_bang_comparison(name) do
    !(name == :foo)
  end

  def good_not_comparison(name) do
    not (name == :foo)
  end
end
