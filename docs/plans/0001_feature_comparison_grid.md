---
title: Feature Comparison Grid
description: Create a comprehensive feature comparison grid that lists all known Elixir style guide rules and indicates which style guides propose each rule.
branch: feature/style-guide-comparison-grid
---

## Overview

Analyze the four style guide documents in the `tmp/` directory and create a comprehensive comparison grid showing which rules are proposed by which guides. The grid will help users understand the Elixir style guide landscape and see where there is consensus or divergence across different guides.

## Tasks

- [x] Analyze categorization schemes across all four guides
  - lexmag uses: Linting (with 7 subcategories), Formatting (with 5 subcategories)
  - Christopher Adams uses: Formatting (3 subcategories), The Guide (11 subcategories)
  - Credo uses: Code Readability, Documentation, Refactoring Opportunities, Software Design, Pitfalls
  - Elixir-lang-code uses: design principles and formatting discussions
  - Create `tmp/categorization-analysis.md` with findings
- [x] Extract all unique rules from each guide with anchors/identifiers
  - Create `tmp/rules-lexmag.md` - extracted rules from lexmag guide
  - Create `tmp/rules-elixir-lang.md` - extracted rules from official Elixir formatter docs
  - Create `tmp/rules-credo.md` - extracted rules from Credo guide
  - Create `tmp/rules-christopheradams.md` - extracted rules from Christopher Adams guide
- [x] Determine categorization strategy (consensus-based vs flat list)
  - Document decision in `tmp/categorization-decision.md`
- [ ] Create comparison matrix in markdown format
  - Rows: individual rules
  - Columns: lexmag, Official Elixir, Credo, Christopher Adams
  - Cell values: indicator if guide proposes this rule
  - Create `tmp/comparison-grid-draft.md` as working document
- [ ] Generate the final comparison grid document
- [ ] Place final document in `docs/` folder with appropriate naming
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

**Input files:**
- `/home/joe/code/gh/joeyates/green/tmp/lexmag-elixir-style-guide.md` (922 lines)
- `/home/joe/code/gh/joeyates/green/tmp/elixir-lang-code.md` (313 lines)
- `/home/joe/code/gh/joeyates/green/tmp/credo-elixir-style-guide.md` (662 lines)
- `/home/joe/code/gh/joeyates/green/tmp/christopheradams-elixir_style_guide.md` (1373 lines)

**Intermediate files (created in tmp/):**
- `tmp/categorization-analysis.md` - analysis of categorization schemes
- `tmp/rules-lexmag.md` - extracted rules from lexmag
- `tmp/rules-elixir-lang.md` - extracted rules from official Elixir
- `tmp/rules-credo.md` - extracted rules from Credo
- `tmp/rules-christopheradams.md` - extracted rules from Christopher Adams
- `tmp/categorization-decision.md` - categorization strategy decision
- `tmp/comparison-grid-draft.md` - working draft of comparison matrix

**Output:**
- `docs/` (final comparison grid location)

## Acceptance Criteria

- All unique rules from all four guides are documented
- Clear indication of which guide(s) propose each rule
- Categorization approach is documented and justified based on analysis
- Format is easily scannable and maintainable
- Document is placed in `docs/` folder
