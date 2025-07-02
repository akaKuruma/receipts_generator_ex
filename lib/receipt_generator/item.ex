defmodule ReceiptGenerator.Item do
  @moduledoc """
  A struct representing an item in a receipt.
  """

  defstruct [:quantity, :name, :unit_price]

  @spec new(integer(), String.t(), Money.t()) :: %__MODULE__{}
  def new(quantity, name, unit_price) when is_integer(quantity) and is_binary(name) and is_struct(unit_price, Money) do
    %__MODULE__{
      quantity: quantity,
      name: name,
      unit_price: unit_price
    }
  end
end
