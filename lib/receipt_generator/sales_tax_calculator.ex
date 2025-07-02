defmodule ReceiptGenerator.SalesTaxCalculator do
  alias ReceiptGenerator.{Item, TaxExempt}

  @spec calculate_sales_tax(Item.t()) :: Money.t()
  def calculate_sales_tax(item) do
    calculate_basic_sales_tax(item)
    |> Decimal.add(calculate_import_duty(item))
    |> round_nickel()
    |> Money.parse!(item.unit_price.currency)
    |> Money.multiply(item.quantity)
  end

  @spec calculate_basic_sales_tax(Item.t()) :: Decimal.t()
  defp calculate_basic_sales_tax(item) do
    if TaxExempt.is_tax_exempt?(item) || is_zero?(item) do
      Decimal.new("0")
    else
      item.unit_price
      |> Money.to_decimal()
      |> Decimal.mult(Decimal.new("0.1"))
    end
  end

  @spec calculate_import_duty(Item.t()) :: Decimal.t()
  defp calculate_import_duty(item) do
    if is_imported?(item) do
      item.unit_price
      |> Money.to_decimal()
      |> Decimal.mult(Decimal.new("0.05"))
    else
      Decimal.new("0")
    end
  end

  @spec is_imported?(Item.t()) :: boolean()
  defp is_imported?(item) do
    item.name |> String.contains?("imported")
  end

  @spec round_nickel(Decimal.t()) :: Decimal.t()
  defp round_nickel(value) do
    value
    |> Decimal.div(Decimal.new("0.05"))
    |> Decimal.round(0, :ceiling)
    |> Decimal.mult(Decimal.new("0.05"))
  end

  @spec is_zero?(Item.t()) :: boolean()
  defp is_zero?(item) do
    Money.equals?(item.unit_price, Money.new(0, item.unit_price.currency))
  end
end
