Code.require_file("assertion.exs", __DIR__)

defmodule MathTest do
  use Assertion

  test "integer can be added and substracted" do
    assert 2 + 3 == 5
    assert 5 - 5 == 0
  end

  test "integer can be multiplied and divided" do
    assert 5 * 5 == 25
    assert 10 / 2 == 5
  end

  test "1 / 0 should raise ArithmeticError " do
    assert_raise ArithmeticError, fn -> 1/0 end
  end
end

MathTest.run
