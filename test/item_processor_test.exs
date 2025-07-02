defmodule ItemProcessorTest do
  use ExUnit.Case

  alias ReceiptGenerator.{ItemProcessor, Item, ReceiptLine}

  describe "process/1" do
    test "returns the item with the total price" do
      item = Item.new(2, "book", Money.parse!("12.49", "USD"))

      expected_receipt_line = %ReceiptLine{
        item: item,
        total_price: Money.parse!("24.98", "USD"),
        sales_tax: Money.parse!("0.00", "USD")
      }

      assert ItemProcessor.process(item) == expected_receipt_line
    end
  end
end
