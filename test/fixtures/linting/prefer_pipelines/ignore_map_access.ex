defmodule IgnoreMapAccess do
  def foo(conn) do
    assigns[:key1][:key2][:key3]
  end
end
