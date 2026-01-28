# green:configure-for-this-file Naming.AvoidCaps, accept_atoms: [:MyAtom, :Other]
defmodule Configurable do
  def foo() do
    [:MyAtom, :BadAtom]
  end
end
