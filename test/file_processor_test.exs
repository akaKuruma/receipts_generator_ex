defmodule ReceiptGenerator.FileProcessorTest do
  use ExUnit.Case
  alias ReceiptGenerator.FileProcessor

  describe "process/3" do
    test "processes input1.txt correctly" do
      input_folder = "test/input"
      output_folder = "test/output_test"

      # Ensure output directory exists
      File.mkdir_p!(output_folder)

      # Process the file
      FileProcessor.process("input1.txt", input_folder, output_folder)

      # Read the generated output
      actual_output = File.read!(Path.join(output_folder, "input1_receipt.txt"))

      # Read the expected output
      expected_output = File.read!("test/output/output1.txt")

      assert actual_output == expected_output

      # Clean up
      File.rm_rf!(output_folder)
    end

    test "processes input2.txt correctly" do
      input_folder = "test/input"
      output_folder = "test/output_test"

      # Ensure output directory exists
      File.mkdir_p!(output_folder)

      # Process the file
      FileProcessor.process("input2.txt", input_folder, output_folder)

      # Read the generated output
      actual_output = File.read!(Path.join(output_folder, "input2_receipt.txt"))

      # Read the expected output
      expected_output = File.read!("test/output/output2.txt")

      assert actual_output == expected_output

      # Clean up
      File.rm_rf!(output_folder)
    end

    test "processes input3.txt correctly" do
      input_folder = "test/input"
      output_folder = "test/output_test"

      # Ensure output directory exists
      File.mkdir_p!(output_folder)

      # Process the file
      FileProcessor.process("input3.txt", input_folder, output_folder)

      # Read the generated output
      actual_output = File.read!(Path.join(output_folder, "input3_receipt.txt"))

      # Read the expected output
      expected_output = File.read!("test/output/output3.txt")

      assert actual_output == expected_output

      # Clean up
      File.rm_rf!(output_folder)
    end

    test "processes all files correctly in parallel" do
      input_folder = "test/input"
      output_folder = "test/output_test"

      # Ensure output directory exists
      File.mkdir_p!(output_folder)

      # Process all files in parallel
      ["input1.txt", "input2.txt", "input3.txt"]
      |> Task.async_stream(&FileProcessor.process(&1, input_folder, output_folder),
                          max_concurrency: System.schedulers_online())
      |> Stream.run()

      # Verify all outputs
      test_cases = [
        {"input1.txt", "input1_receipt.txt", "test/output/output1.txt"},
        {"input2.txt", "input2_receipt.txt", "test/output/output2.txt"},
        {"input3.txt", "input3_receipt.txt", "test/output/output3.txt"}
      ]

      for {_input_file, output_file, expected_file} <- test_cases do
        actual_output = File.read!(Path.join(output_folder, output_file))
        expected_output = File.read!(expected_file)
        assert actual_output == expected_output
      end

      # Clean up
      File.rm_rf!(output_folder)
    end
  end
end
