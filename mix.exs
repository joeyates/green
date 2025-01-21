defmodule ExCop.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_cop,
      version: "0.1.0",
      elixir: "~> 1.14",
      deps: deps(),
      description: "Format Elixir code according to a consistent style",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/joeyates/ex_cop"
      },
      maintainers: ["Joe Yates"]
    }
  end
end
