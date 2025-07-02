defmodule SalesTaxCalculatorTest do
  use ExUnit.Case
  alias ReceiptGenerator.{SalesTaxCalculator, Item}

  describe "calculate_sales_tax/1" do
    test "handles zero tax correctly" do
      item = Item.new(1, "book", Money.new(1000, "USD"))
      result = SalesTaxCalculator.calculate_sales_tax(item)

      assert Money.equals?(result, Money.new(0, "USD"))
    end

    test "calculates tax for imported boxes of chocolates" do
      item = Item.new(3, "imported boxes of chocolates", Money.parse!("11.25", "USD"))
      result = SalesTaxCalculator.calculate_sales_tax(item)

      assert Money.equals?(result, Money.parse!("1.80", "USD"))
    end

    test "calculates tax for tax-exempt non-imported item (book)" do
      item = Item.new(2, "book", Money.new(1249, "USD"))
      result = SalesTaxCalculator.calculate_sales_tax(item)

      assert Money.equals?(result, Money.new(0, "USD"))
    end

    test "calculates tax for non-exempt non-imported item (music CD)" do
      item = Item.new(1, "music CD", Money.new(1499, "USD"))
      result = SalesTaxCalculator.calculate_sales_tax(item)

      assert Money.equals?(result, Money.new(150, "USD"))
    end

    test "calculates tax for imported tax-exempt item (imported box of chocolates)" do
      item = Item.new(1, "imported box of chocolates", Money.new(1000, "USD"))
      result = SalesTaxCalculator.calculate_sales_tax(item)

      assert Money.equals?(result, Money.new(50, "USD"))
    end

    test "calculates tax for imported non-exempt item (imported bottle of perfume)" do
      item = Item.new(1, "imported bottle of perfume", Money.new(4750, "USD"))
      result = SalesTaxCalculator.calculate_sales_tax(item)

      assert Money.equals?(result, Money.new(715, "USD"))
    end

    test "handles rounding edge cases" do
      item = Item.new(1, "taxable item", Money.parse!("10.01", "USD"))
      result = SalesTaxCalculator.calculate_sales_tax(item)

      assert Money.equals?(result, Money.parse!("1.05", "USD"))
    end

    test "handles multiple quantity correctly" do
      item = Item.new(2, "taxable item", Money.new(500, "USD"))
      result = SalesTaxCalculator.calculate_sales_tax(item)

      assert Money.equals?(result, Money.new(100, "USD"))
    end
  end
end
