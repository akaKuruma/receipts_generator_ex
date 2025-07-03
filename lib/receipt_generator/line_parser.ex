defmodule ReceiptGenerator.LineParser do
  alias ReceiptGenerator.Item

  @line_pattern ~r/^(?<item_quantity>\d+)\s+(?<item_name>.+)\s+at\s+(?<item_unit_price>\d+\.\d{2})$/

  def parse(line) do
    line
    |> parse_line()
    |> build_item()
  end

  defp parse_line(line) do
    case Regex.named_captures(@line_pattern, line) do
      %{"item_quantity" => quantity, "item_name" => name, "item_unit_price" => unit_price} ->
        # Convert price to cents (multiply by 100)
        price_in_cents =
          unit_price
          |> String.to_float()
          |> Kernel.*(100)
          |> round()

        {
          String.to_integer(quantity),
          name,
          Money.new(price_in_cents, :USD)
        }

      _ ->
        raise "Invalid line: #{line}"
    end
  end

  defp build_item({quantity, name, unit_price}) do
    %Item{
      quantity: quantity,
      name: name,
      unit_price: unit_price
    }
  end
end
