# green:configure-for-this-file Naming.AvoidCaps, accept_atoms: [:MyAtom, :OtherAtom, :ExtraAtom]
defmodule Configurable do
  def foo() do
    [:MyAtom, :OtherAtom, :BadAtom]
  end
end
