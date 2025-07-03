defmodule ReceiptGenerator.ReceiptLine do
  alias ReceiptGenerator.Item

  defstruct [:item, :total_price, :sales_tax]

  @spec new(Item.t(), Money.t(), Money.t()) :: %__MODULE__{}
  def new(item, total_price, sales_tax) when is_struct(item, Item) and is_struct(total_price, Money) and is_struct(sales_tax, Money) do
    %__MODULE__{
      item: item,
      total_price: total_price,
      sales_tax: sales_tax
    }
  end

  @spec new(Item.t(), nil, nil) :: %__MODULE__{}
  def new(item, _total_price, _sales_tax) when is_struct(item, Item) do
    %__MODULE__{
      item: item,
      total_price: Money.new(0, "USD"),
      sales_tax: Money.new(0, "USD")
    }
  end

  def new(_item, _total_price, _sales_tax), do: raise("Invalid arguments")
end
