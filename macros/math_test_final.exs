defmodule MathTest do
  use Assertion

  test "integer can be added and substracted" do
    assert 2 + 3 == 5
    assert 5 - 5 == 10
  end

  test "integer can be multiplied and divided" do
    assert 5 * 5 == 25
    assert 10 / 2 == 5
  end

end
