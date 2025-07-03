defmodule ReceiptGenerator.CLITest do
  use ExUnit.Case
  use Mimic
  import ExUnit.CaptureIO

  doctest ReceiptGenerator.CLI

  describe "main/1" do
    test "succesfully processes valid arguments" do

      expect(ReceiptGenerator, :generate_receipts, fn input, output ->
        assert input == "input/folder"
        assert output == "output/folder"
        :ok
      end)

      output = capture_io(fn ->
        ReceiptGenerator.CLI.main(["input/folder", "output/folder"])
      end)

      assert output == "Receipts generated successfully\n"
    end

    test "handles invalid arguments" do
      expect(ReceiptGenerator, :generate_receipts, fn _input, _output ->
        raise ArgumentError, message: "Invalid input folder"
      end)

      output = capture_io(fn ->
        ReceiptGenerator.CLI.main(["invalid/arguments"])
      end)

      assert output == "Error: %ArgumentError{message: \"Invalid input folder\"}\n"
    end
  end
end
