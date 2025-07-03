defmodule ReceiptGenerator.FileProcessor do
  alias ReceiptGenerator.{LineParser, ItemProcessor}

  @spec process(String.t(), String.t(), String.t()) :: :ok
  def process(file_name, input_folder, output_folder) do
    file_content = File.read!(Path.join(input_folder, file_name))

    {receipt_lines, {total_sales_tax, total_amount}} = parse_and_calculate(file_content)

    write_receipt(output_folder, file_name, receipt_lines, total_sales_tax, total_amount)
  end

  defp parse_and_calculate(file_content) do
    initial_totals = {Money.new(0, :USD), Money.new(0, :USD)}

    file_content
    |> String.split("\n", trim: true)
    |> Enum.map(&LineParser.parse/1)
    |> Enum.map_reduce(initial_totals, fn item, {total_sales_tax, total_amount} ->
      receipt_line = ItemProcessor.process(item)

      new_total_sales_tax = Money.add(total_sales_tax, receipt_line.sales_tax)
      new_total_amount = Money.add(total_amount, receipt_line.total_price)

      {receipt_line, {new_total_sales_tax, new_total_amount}}
    end)
  end

  defp write_receipt(output_folder, filename, receipt_lines, total_sales_tax, total_amount) do
    output_filename =
      filename
      |> Path.rootname()
      |> Kernel.<>("_receipt.txt")

    output_path = Path.join(output_folder, output_filename)

    receipt_content = format_receipt(receipt_lines, total_sales_tax, total_amount)

    File.write!(output_path, receipt_content)
  end

  defp format_receipt(receipt_lines, total_sales_tax, total_amount) do
    item_lines =
      receipt_lines
      |> Enum.map(fn line ->
        "#{line.item.quantity} #{line.item.name}: #{format_money(line.total_price)}"
      end)
      |> Enum.join("\n")

    """
    #{item_lines}
    Sales Taxes: #{format_money(total_sales_tax)}
    Total: #{format_money(total_amount)}
    """
  end

  # Format money as simple decimal without currency symbols
  defp format_money(money) do
    # Convert cents to dollars with exactly 2 decimal places
    dollars = money.amount / 100.0
    :io_lib.format("~.2f", [dollars]) |> to_string()
  end
end
