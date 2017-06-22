ExUnit.start
Code.require_file("../../advanced_code_gen/mime.exs", __DIR__)

defmodule TranslatorTest do
  use ExUnit.Case

  test "it find extention from type" do
    assert Mime.exts_from_type("application/msword") == [".doc", ".dot"]
  end

  test "it find type from extention" do
    assert Mime.type_from_ext(".doc") == "application/msword"
  end

  test "it test if type exists" do
     assert Mime.valid_type?("application/msword") == true
  end
end
