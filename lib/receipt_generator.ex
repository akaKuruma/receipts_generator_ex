defmodule ReceiptGenerator do
  @moduledoc """
  Documentation for `ReceiptGenerator`.
  """

  @doc """
  Generate a receipt from a folder of item lists.

  ## Examples

      iex> ReceiptGenerator.generate_receipt("input/folder", "output/folder")
      :ok
  """
  def generate_receipt(input_folder, output_folder) when is_binary(input_folder) and is_binary(output_folder) do
    IO.puts("Generating receipt from #{input_folder} to #{output_folder}")
    # input_folder
    # |> File.ls!()
    # |> Enum.map(&File.read!(Path.join(input_folder, &1)))
    # |> Enum.map(&parse_receipt(&1))
    # |> Enum.map(&generate_receipt_html(&1))
    # |> Enum.map(&File.write!(Path.join(output_folder, &1)))
  end
end
