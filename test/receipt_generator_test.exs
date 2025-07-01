defmodule ReceiptGeneratorTest do
  use ExUnit.Case
  doctest ReceiptGenerator

  test "greets the world" do
    assert ReceiptGenerator.hello() == :world
  end
end
