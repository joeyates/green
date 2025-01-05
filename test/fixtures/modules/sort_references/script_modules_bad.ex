#!/usr/bin/env elixir

require Logger

import SomeModule

defmodule MyModule do
  # A comment
  require AnotherModule
  use SomeMacro
end
