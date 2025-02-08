test_files =
  "test/**/*.{ex,exs}"
  |> Path.wildcard()
  |> Enum.filter(&(!String.starts_with?(&1, "test/fixtures")))

[
  inputs: ["{mix,.formatter}.exs", "lib/**/*.ex"] ++ test_files,
  locals_without_parens: [assert: 1, refute: 1],
  plugins: [Green.Lexmag.ElixirStyleGuideFormatter]
]
