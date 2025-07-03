defmodule ReceiptGeneratorTest do
  use ExUnit.Case
  use Mimic

  doctest ReceiptGenerator

  setup :verify_on_exit!

  # Mock for doctest
  setup do
    File
    |> stub(:ls!, fn _ -> [] end)

    ReceiptGenerator.FileProcessor
    |> stub(:process, fn _, _, _ -> :ok end)

    :ok
  end

  describe "generate_receipts/2" do
    test "processes all files in parallel using FileProcessor" do
      input_folder = "test_input"
      output_folder = "test_output"

      # Mock File.ls! to return a list of files
      File
      |> expect(:ls!, fn ^input_folder -> ["file1.txt", "file2.txt", "file3.txt"] end)

      # Mock FileProcessor.process to be called for each file
      ReceiptGenerator.FileProcessor
      |> expect(:process, 3, fn file, ^input_folder, ^output_folder ->
        # Verify that each file is processed with correct arguments
        assert file in ["file1.txt", "file2.txt", "file3.txt"]
        :ok
      end)

      # Call the function under test
      result = ReceiptGenerator.generate_receipts(input_folder, output_folder)

      # Verify the return value
      assert result == :ok
    end

    test "handles empty folder" do
      input_folder = "empty_folder"
      output_folder = "test_output"

      # Mock File.ls! to return empty list
      File
      |> expect(:ls!, fn ^input_folder -> [] end)

      # FileProcessor.process should not be called (use reject for 0 calls)
      ReceiptGenerator.FileProcessor
      |> reject(:process, 3)

      # Call the function under test
      result = ReceiptGenerator.generate_receipts(input_folder, output_folder)

      # Verify the return value
      assert result == :ok
    end

    test "passes correct arguments to FileProcessor for each file" do
      input_folder = "input"
      output_folder = "output"
      files = ["receipt1.txt", "receipt2.txt"]

      # Mock File.ls! to return specific files
      File
      |> expect(:ls!, fn ^input_folder -> files end)

      # Mock FileProcessor.process and capture arguments
      ReceiptGenerator.FileProcessor
      |> expect(:process, fn file, folder_in, folder_out ->
        assert file in files
        assert folder_in == input_folder
        assert folder_out == output_folder
        :ok
      end)
      |> expect(:process, fn file, folder_in, folder_out ->
        assert file in files
        assert folder_in == input_folder
        assert folder_out == output_folder
        :ok
      end)

      # Call the function under test
      result = ReceiptGenerator.generate_receipts(input_folder, output_folder)

      # Verify the return value
      assert result == :ok
    end
  end
end
