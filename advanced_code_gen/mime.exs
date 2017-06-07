defmodule Mime do
  for line <- File.stream!(Path.join([__DIR__, "mimes.txt"]), [], :line) do
    [type, rest] = line
      |> String.split("\t")
      |> Enum.map(&String.strip(&1))
    extentions = String.split(rest, ~r/,\s?/)

    def exts_from_type(unquote(type)), do: unquote(extentions)
    def type_from_ext(ext) when ext in unquote(extentions), do: unquote(type)
  end

  def exts_from_type(_type), do: nil
  def type_from_ext(_ext), do: nil
  def valid_type?(type), do: exts_from_type(type) |> Enum.any?
end
