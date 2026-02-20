---
title: Feature Comparison Grid
description: Create a comprehensive feature comparison grid that lists all known Elixir style guide rules and indicates which style guides propose each rule.
branch: feature/style-guide-comparison-grid
---

## Overview

Analyze the four style guide documents in the `tmp/` directory and create a comprehensive comparison grid showing which rules are proposed by which guides. The grid will help users understand the Elixir style guide landscape and see where there is consensus or divergence across different guides.

## Tasks

- [ ] Analyze categorization schemes across all four guides
  - lexmag uses: Linting (with 7 subcategories), Formatting (with 5 subcategories)
  - Christopher Adams uses: Formatting (3 subcategories), The Guide (11 subcategories)
  - Credo uses: Code Readability, Documentation, Refactoring Opportunities, Software Design, Pitfalls
  - Elixir-lang-code uses: design principles and formatting discussions
- [ ] Extract all unique rules from each guide with anchors/identifiers
- [ ] Determine categorization strategy (consensus-based vs flat list)
- [ ] Create comparison matrix in markdown format
  - Rows: individual rules
  - Columns: lexmag, Official Elixir, Credo, Christopher Adams
  - Cell values: indicator if guide proposes this rule
- [ ] Generate the comparison grid document
- [ ] Place in `docs/` folder with appropriate naming
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- `/home/joe/code/gh/joeyates/green/tmp/lexmag-elixir-style-guide.md` (922 lines)
- `/home/joe/code/gh/joeyates/green/tmp/elixir-lang-code.md` (313 lines)
- `/home/joe/code/gh/joeyates/green/tmp/credo-elixir-style-guide.md` (662 lines)
- `/home/joe/code/gh/joeyates/green/tmp/christopheradams-elixir_style_guide.md` (1373 lines)
- `docs/` (output location)

## Acceptance Criteria

- All unique rules from all four guides are documented
- Clear indication of which guide(s) propose each rule
- Categorization approach is documented and justified based on analysis
- Format is easily scannable and maintainable
- Document is placed in `docs/` folder
