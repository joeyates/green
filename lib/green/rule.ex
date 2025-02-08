defmodule Green.Rule do
  @moduledoc """
  This is the Rule behaviour.
  """

  @type forms() :: tuple()
  @type comment() :: map()
  @callback apply({forms(), [comment()]}, keyword()) :: {forms(), [comment()]}
end
