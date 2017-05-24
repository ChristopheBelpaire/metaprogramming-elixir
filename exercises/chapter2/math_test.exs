defmodule MathTest do
  use Assertion

  test "integer can be added and substracted" do
    assert 2 + 3 == 5
    assert 5 - 5 == 0
  end

  test "three is bigger than 2" do
    assert 3 > 2
  end

  test "true should be true" do
    assert true
  end

  test "refute equals" do
    refute 2 + 3 == 6
  end

end
