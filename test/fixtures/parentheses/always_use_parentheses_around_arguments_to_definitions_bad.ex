defmodule MyModule do
  defmacro no_args_macro do
    :ok
  end

  defmacrop private_no_args_macro do
    :private_ok
  end

  def no_args do
    :ok
  end

  def call_private_functions() do
    private_no_args()
  end

  defp private_no_args do
    :private_ok
  end
end
