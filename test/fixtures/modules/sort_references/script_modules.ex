#!/usr/bin/env elixir

require Logger

import SomeModule

defmodule MyModule do
  # A comment
  use SomeMacro

  require AnotherModule
end
