defmodule ReceiptGenerator.CLI do
  @moduledoc """
  CLI for the ReceiptGenerator application.
  """

  @doc """
  Main entry point for the CLI.
  """
  def main(args) do
    args
    |> parse_args()
    |> process()
  end

  defp parse_args([input_folder, output_folder]) do
    %{input_folder: input_folder, output_folder: output_folder}
  end

  defp parse_args(_) do
    IO.puts("Usage: receipt_generator <input_folder> <output_folder>")
    System.halt(1)
  end

  defp process(args) do
    try do
      ReceiptGenerator.generate_receipt(args.input_folder, args.output_folder)
      IO.puts("Receipts generated successfully")
    rescue
      error ->
        IO.puts("Error: #{inspect(error)}")
        System.halt(1)
    end
  end
end
