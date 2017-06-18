ExUnit.start
Code.require_file("while.exs", __DIR__)

defmodule WhileTest do
  use ExUnit.Case
  import Loop

  test "Is this really taht easy ?" do
    assert Code.ensure_loaded?(Loop)
  end
end
