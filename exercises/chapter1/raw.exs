defmodule Raw do
  defmacro three_plus_one do
    {:+, [context: Elixir, import: Kernel], [3, 2]}
  end
end
