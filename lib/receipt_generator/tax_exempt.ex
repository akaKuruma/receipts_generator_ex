defmodule ReceiptGenerator.TaxExempt do
  alias ReceiptGenerator.Item

  @food_keywords ["chocolate bar", "box of chocolates", "boxes of chocolates"]
  @book_keywords ["book"]
  @medical_keywords ["headache pills"]

  @spec is_tax_exempt?(Item.t()) :: boolean()
  def is_tax_exempt?(item) do
    is_food?(item) or is_book?(item) or is_medical_product?(item)
  end

  @spec is_food?(Item.t()) :: boolean()
  defp is_food?(item) do
    contains_any_keyword?(item.name, @food_keywords)
  end

  @spec is_book?(Item.t()) :: boolean()
  defp is_book?(item) do
    contains_any_keyword?(item.name, @book_keywords)
  end

  @spec is_medical_product?(Item.t()) :: boolean()
  defp is_medical_product?(item) do
    contains_any_keyword?(item.name, @medical_keywords)
  end

  @spec contains_any_keyword?(String.t(), [String.t()]) :: boolean()
  defp contains_any_keyword?(item_name, keywords) do
    lower_case_name = String.downcase(item_name)
    Enum.any?(keywords, &String.contains?(lower_case_name, &1))
  end
end
