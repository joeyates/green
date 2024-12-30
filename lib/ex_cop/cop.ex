defmodule ExCop.Cop do
  @moduledoc """
  This is the Cop behaviour.
  """

  @type forms() :: tuple()
  @type comment() :: map()
  @callback apply({forms(), [comment()]}, keyword()) :: {forms(), [comment()]}
end
