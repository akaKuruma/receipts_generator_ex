defmodule ReceiptGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :receipt_generator,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
    ]
  end

  def escript do
    [main_module: ReceiptGenerator.CLI]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mimic, "~> 1.12", only: :test},
      {:money, "~> 1.14"},
      {:decimal, "~> 2.3"}
    ]
  end
end
