defmodule ModuleReferenceEamples do
  import Foo.Bar.Baz
  require Logger

  use MacroModule

  require SomeRequire

  alias Some.Nested.Module, warn: false
end
