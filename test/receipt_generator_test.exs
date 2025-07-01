defmodule ReceiptGeneratorTest do
  use ExUnit.Case
  doctest ReceiptGenerator

  test "generate_receipt" do
    assert ReceiptGenerator.generate_receipt("input/folder", "output/folder") == :ok
  end
end
