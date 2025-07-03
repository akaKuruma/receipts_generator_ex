defmodule ReceiptGenerator do
  @moduledoc """
  Documentation for `ReceiptGenerator`.
  """

  alias ReceiptGenerator.FileProcessor

  @doc """
  Generate a receipt from a folder of item lists in parallel.

  ## Examples

      iex> ReceiptGenerator.generate_receipts("input", "output")
      :ok
  """
  @spec generate_receipts(binary(), binary()) :: :ok
  def generate_receipts(input_folder, output_folder) when is_binary(input_folder) and is_binary(output_folder) do
    input_folder
    |> File.ls!()
    |> Task.async_stream(&FileProcessor.process(&1, input_folder, output_folder), max_concurrency: System.schedulers_online())
    |> Stream.run()
  end
end
