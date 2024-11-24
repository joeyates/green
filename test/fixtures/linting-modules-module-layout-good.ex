defmodule ModuleReferenceEamples do
  use MacroModule

  import Foo.Bar.Baz

  alias Some.Nested.Module, warn: false

  require Logger
  require SomeRequire
end
