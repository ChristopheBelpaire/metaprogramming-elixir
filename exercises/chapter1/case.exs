defmodule ControlFlow do
  defmacro unless(expression, do: block) do
    quote do
      case !unquote(expression) do
        x when x in [false, nil] ->
          nil
        _ ->
          unquote(block)
      end
    end
  end
end
