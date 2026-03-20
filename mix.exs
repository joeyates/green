defmodule Green.MixProject do
  use Mix.Project

  @version "0.1.11"

  def project() do
    [
      app: :green,
      version: @version,
      elixir: "~> 1.14",
      deps: deps(),
      description: "Format Elixir code according to a consistent style",
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      test_ignore_filters: [~r(test/fixtures), ~r(test/projects)]
    ]
  end

  def cli() do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "test/projects/validation/lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps() do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18", only: :test}
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
      "docs/elixir-style-guide-comparison.md"
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
