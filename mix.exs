defmodule Green.MixProject do
  use Mix.Project

  @version "0.1.9"

  def project() do
    [
      app: :green,
      version: @version,
      elixir: "~> 1.14",
      deps: deps(),
      description: "Format Elixir code according to a consistent style",
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps() do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs() do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extra_section: "GUIDES",
      extras: extras()
    ]
  end

  defp extras() do
    [
      "README.md",
      "docs/lexmag.md"
    ]
  end

  defp package() do
    %{
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/joeyates/green"
      },
      maintainers: ["Joe Yates"]
    }
  end
end
