defmodule ReceiptGenerator.TaxExemptTest do
  use ExUnit.Case, async: true
  alias ReceiptGenerator.{TaxExempt, Item}

  describe "is_tax_exempt?/1" do
    test "returns true for food items containing 'chocolate bar'" do
      item = Item.new(1, "chocolate bar", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for food items with 'chocolate bar' in different case" do
      item = Item.new(1, "CHOCOLATE BAR", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for food items containing 'box of chocolates'" do
      item = Item.new(1, "box of chocolates", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for food items with 'box of chocolates' in different case" do
      item = Item.new(1, "BOX OF CHOCOLATES", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for food items with 'chocolate bar' as part of larger description" do
      item = Item.new(1, "imported chocolate bar", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for food items with 'box of chocolates' as part of larger description" do
      item = Item.new(1, "imported box of chocolates", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for book items containing 'book'" do
      item = Item.new(1, "book", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for book items with 'book' in different case" do
      item = Item.new(1, "BOOK of recipes", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for book items with 'book' as part of larger word" do
      item = Item.new(1, "notebook", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for medical items containing 'headache pills'" do
      item = Item.new(1, "packet of headache pills", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for medical items with 'headache pills' in different case" do
      item = Item.new(1, "HEADACHE PILLS", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns false for non-exempt items" do
      item = Item.new(1, "music CD", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for perfume items" do
      item = Item.new(1, "bottle of perfume", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for imported non-exempt items" do
      item = Item.new(1, "imported bottle of perfume", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for items with similar but not matching chocolate keywords" do
      item = Item.new(1, "choco bar", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for items with just 'chocolate' without complete phrase" do
      item = Item.new(1, "chocolate", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for items with 'chocolate' in other contexts" do
      item = Item.new(1, "chocolate cake", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for items with partial chocolate phrases" do
      item = Item.new(1, "box of chocolate", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for items with partial book matches that don't contain 'book'" do
      item = Item.new(1, "boo", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for items with partial medical matches" do
      item = Item.new(1, "headache", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "returns false for empty item name" do
      item = Item.new(1, "", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == false
    end

    test "handles items with special characters in name" do
      item = Item.new(1, "chocolate bar!", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "handles items with numbers in name" do
      item = Item.new(1, "book 123", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end

    test "returns true for items matching multiple categories" do
      # This is a theoretical case - an item that could match multiple keywords
      item = Item.new(1, "chocolate bar book", Money.new(100, :USD))
      assert TaxExempt.is_tax_exempt?(item) == true
    end
  end
end
