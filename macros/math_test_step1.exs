defmodule MathTest do
  use Assertion

  test "integer can be added and substracted" do
    assert 1 + 1 == 2
    assert 2 + 3 == 5
    assert 5 - 5 == 10
  end
end
