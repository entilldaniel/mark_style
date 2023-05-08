defmodule MarkStyleTest do
  use ExUnit.Case
  doctest MarkStyle
  @contents """
    # Hello World
    This is the text for the test
    `IO.puts("I like elixir")`
    """
  
  test "adds classes to tags" do
    

    map = %{
      p: "text-lg",
      em: "text-bold",
      code: "font-monospaced"
    }

    res = MarkStyle.as_styled(@contents, map)

    assert String.contains?(res, [
             "class=\"text-lg\"",
             "class=\"text-bold\"",
             "class=\"font-monospaced\""
           ])
  end

  test "doesn't fail on empty map" do
    res = MarkStyle.as_styled(@contents, %{})
    assert res != nil
  end

  test "doesn't fail on bad values" do
    res = MarkStyle.as_styled(@contents, %{p: 1})
    assert res != nil
  end

  test "doesn't fail on unbalanced backticks" do
    res = MarkStyle.as_styled("This is the test `", %{p: 1})
    assert res != nil
  end  
  
end
