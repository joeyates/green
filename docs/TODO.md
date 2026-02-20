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
