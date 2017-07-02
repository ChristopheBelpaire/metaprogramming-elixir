defmodule Html do
  @extrernal_resource tags_path = Path.join([__DIR__, "tags.txt"])
  @tags (for line <- File.stream!(tags_path, [], :line) do
    line |> String.strip |> String.to_atom
  end)

  defmacro markup(do: block) do
    quote do
      {:ok, var!(buffer, Html)} = start_buffer([])
      {:ok, var!(indent, Html)} = start_indent_counter(0)
      unquote(Macro.postwalk(block, &postwalk/1))
      result = render(var!(buffer, Html))
      :ok = stop_buffer(var!(buffer, Html))
      :ok = stop_buffer(var!(indent, Html))
      result
    end
  end

  def postwalk({:text, _meta, [string]}) do
    quote do
      tabs = render_tabs(var!(indent, Html))
      put_buffer(var!(buffer, Html), to_string(tabs <> unquote(string) <> "\n"))
    end
  end
  def postwalk({tag_name, _meta, [[do: inner]]}) when tag_name in @tags do
    quote do: tag(unquote(tag_name), [], do: unquote(inner))
  end
  def postwalk({tag_name, _meta, [attrs, [do: inner]]}) when tag_name in @tags do
    quote do: tag(unquote(tag_name), unquote(attrs), do: unquote(inner))
  end
  def postwalk(ast), do: ast

  def start_buffer(state), do: Agent.start_link(fn -> state end)

  def stop_buffer(buff), do: Agent.stop(buff)

  def put_buffer(buff, content), do: Agent.update(buff, &[content | &1])

  def render(buff), do: Agent.get(buff,&(&1)) |> Enum.reverse |> Enum.join("")

  def start_indent_counter(level), do: Agent.start_link(fn -> level end)

  def stop_indent_counter(indent), do: Agent.stop(indent)

  def incr_indent(indent), do: Agent.update(indent, &(&1 + 1))

  def decr_indent(indent), do: Agent.update(indent, &(&1 - 1))

  def render_tabs(indent) do
    level = Agent.get(indent,&(&1))
    String.duplicate("\t",level)
  end

  defmacro tag(name, attrs \\ [], do: inner) do
    quote do
      tabs = render_tabs(var!(indent, Html))
      put_buffer var!(buffer, Html), open_tag(unquote_splicing([name, attrs]), tabs)
      incr_indent(var!(indent, Html))
      unquote(inner)
      decr_indent(var!(indent, Html))
      put_buffer var!(buffer, Html), tabs <> "</#{unquote(name)}>\n"
    end
  end

  def open_tag(name, [], tabs), do: tabs <> "<#{name}>\n"
  def open_tag(name, attrs, tabs) do
    attr_html = for {key, val} <- attrs, into: "", do: " #{key}=\"#{val}\""
    tabs <> "<#{name}#{attr_html}>\n"
  end
end
