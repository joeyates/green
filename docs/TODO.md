# Feature Comparison Grid

Status: [x]

## Description

Create a comprehensive feature comparison grid that lists all known Elixir style guide rules and indicates which style guides propose each rule. This will provide a complete overview of the style guide landscape without initially focusing on Green's implementation status.

## Technical Specifics

- Style guides to compare:
  - lexmag/elixir-style-guide (https://github.com/lexmag/elixir-style-guide) - Green's base
  - Official Elixir style guide (https://hexdocs.pm/elixir_style_guide/readme.html)
  - Credo style guide (https://github.com/rrrene/elixir-style-guide)
  - Christopher Adams' style guide (https://github.com/christopheradams/elixir_style_guide)
- Grid format: rows = rules, columns = style guides
- For each rule/guide intersection, indicate whether that guide proposes the rule
- Categorization: analyze how each guide categorizes rules; only use categories if there's near-consensus across guides, otherwise present as flat list
- Document all unique rules across all guides
- Add to documentation under docs/ folder

# Test Elixir Formatter Behavior Against Style Guide Rules

Status: [ ]

## Description

Create a comprehensive test suite that validates which rules from the style guide comparison document are actually enforced by the official Elixir formatter (`mix format`). This will provide empirical data about formatter behavior and help identify gaps between documented rules and actual formatter implementation.

The comparison document currently has limited information about what the official Elixir formatter actually does - this testing infrastructure will address that gap by systematically testing formatter behavior against each rule.

## Technical Specifics

- Create a test Mix project under `test/projects/elixir_formatter/` to provide an isolated environment for running `mix format`
- For each rule marked with type "F" (Formatting) in [elixir-style-guide-comparison.md](docs/elixir-style-guide-comparison.md), create:
  - A "bad" example file that violates the rule
  - An "expected" file showing the corrected code
  - A test that runs `mix format` and verifies the transformation
  - If the formatter doesn't enforce a rule, write a negative test like `test "doesn't do X" ...` that verifies the code remains unchanged
- Test infrastructure:
  - Tag all tests with `@tag :elixir_formatter`
  - Configure `test_helper.exs` with `ExUnit.configure(exclude: [elixir_formatter: true])` so tests don't run by default
  - Tests can be run explicitly with `mix test --include elixir_formatter`
  - Programmatically invoke `mix format` on test files
  - Compare output against expected results
- Update [elixir-style-guide-comparison.md](docs/elixir-style-guide-comparison.md) with empirical results based on test outcomes
- Priority: Focus first on rules where the "Official Elixir" column has a checkmark, as these are claimed to be formatter-enforced
- Approximately ~45 formatting rules to test across categories: whitespace, indentation, parentheses, numeric literals, data structures, etc.
