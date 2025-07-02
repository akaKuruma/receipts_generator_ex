defmodule ReceiptGenerator.ItemProcessor do
  alias ReceiptGenerator.{Item, ReceiptLine, SalesTaxCalculator}

  @spec process(Item.t()) :: ReceiptLine.t()
  def process(item) do
    %ReceiptLine{item: item}
    |> calculate_sales_tax()
    |> calculate_total_price()
  end

  defp calculate_sales_tax(receipt_line) do
    receipt_line
    |> Map.put(:sales_tax, SalesTaxCalculator.calculate_sales_tax(receipt_line.item))
  end

  defp calculate_total_price(receipt_line) do
    receipt_line
    |> Map.put(:total_price, total_price(receipt_line))
  end

  defp total_price(receipt_line) do
    item = receipt_line.item

    item.unit_price
    |> Money.multiply(item.quantity)
    |> Money.add(receipt_line.sales_tax)
  end
end
