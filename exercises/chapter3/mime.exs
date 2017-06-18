defmodule Mime do

  defmacro __using__(mapping) do
    ast = for {type, extentions} <- mapping do
      quote do
        def exts_from_type(unquote(Atom.to_string(type))), do: unquote(extentions)
        def type_from_ext(ext) when ext in unquote(extentions), do: unquote(Atom.to_string(type))
      end
    end

    quote do
      unquote ast
      def exts_from_type(_type), do: nil
      def type_from_ext(_ext), do: nil
      def valid_type?(type), do: exts_from_type(type) |> Enum.any?
    end
  end
end
