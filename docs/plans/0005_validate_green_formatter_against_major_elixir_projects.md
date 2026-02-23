---
title: Validate Green Formatter Against Major Elixir Projects
description: Create an automated testing system that validates Green's formatter against real-world Elixir codebases to identify which rules are triggered and potential issues.
branch: feature/validate-against-major-projects
---

## Overview

This plan creates an automated testing infrastructure that clones major Elixir projects and runs Green's implementation of lexmag's style guide against them, testing each rule individually to precisely identify which rules trigger on real-world code. The system captures results as JSON with line-level granularity, enabling analysis of rule effectiveness and potential false positives.

**Testing Strategy:** For each project, first verify it's already formatted (baseline check), then test each Green rule individually by enabling only that rule. This isolates which specific rules trigger changes and on which lines.

**Target Projects:** elixir-lang (monorepo), Phoenix, Phoenix LiveView, Hexpm, Nerves, Absinthe, Broadway, Credo

## Tasks

- [ ] Create directory structure under `test/projects/validation/` for cloned repositories and results
- [ ] Implement repository cloning script that checks out the specified projects at their latest stable tags/releases
- [ ] Capture and record commit SHA for each cloned project
- [ ] Create elixir-lang monorepo detection logic to identify and list subprojects (lib/elixir, lib/ex_unit, lib/mix, lib/iex, lib/logger, etc.)
- [ ] Implement baseline check: run `mix format --check-formatted` without Green to verify project is already formatted
- [ ] Implement logic to temporarily install the latest published Green version as a dependency in each project's mix.exs
- [ ] Create per-rule validation logic that iterates through each Green rule individually
- [ ] For each rule, modify `.formatter.exs` to enable only that specific rule
- [ ] Run `mix format --check-formatted` and parse output to extract affected files and line numbers
- [ ] Implement diff parser to extract line numbers from `mix format` output
- [ ] Create JSON result schema with metadata, baseline, and per-rule results
- [ ] Implement result collection and JSON serialization for each project run
- [ ] Create summary report generator that aggregates statistics across all projects
- [ ] Generate per-project statistics: baseline status, rules triggered, files affected per rule
- [ ] Generate aggregate statistics: most common rules across all projects, total compliance rate
- [ ] Add .gitignore entries for cloned repositories and result files
- [ ] Document how to run validation, interpret results, and update baselines
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- `lib/green/lexmag/elixir_style_guide_formatter.ex` - Update to support per-rule configuration
- `test/projects/validation/validate.exs` - Main validation script
- `test/projects/validation/lib/validator.ex` - Core validation logic
- `test/projects/validation/lib/diff_parser.ex` - Parse mix format output for line numbers
- `test/projects/validation/lib/result_writer.ex` - JSON serialization
- `test/projects/validation/results/` - Directory for JSON result files
- `test/projects/validation/.gitignore` - Exclude cloned repos
- `test/projects/validation/README.md` - Documentation

## Acceptance Criteria

- Script successfully clones all 8 specified projects at their latest stable versions
- Commit SHA is captured and recorded for each cloned project
- elixir-lang monorepo is correctly parsed into individual subprojects for separate analysis
- Baseline check runs `mix format --check-formatted` without Green and records result
- Latest published Green version is installed as a dependency in each cloned project
- For each Green rule, the validator creates a custom `.formatter.exs` enabling only that rule
- `mix format --check-formatted` output is parsed to extract file paths and line numbers
- Results stored as JSON with schema:
  ```json
  {
    "metadata": {
      "project": "ProjectName",
      "repository": "https://...",
      "commit_sha": "abc123",
      "tag_or_branch": "v1.0.0",
      "green_version": "0.3.0",
      "validated_at": "ISO-8601 timestamp"
    },
    "baseline": {
      "clean": true/false,
      "files_needing_formatting": 0
    },
    "rules": [
      {
        "rule": "Green.Rules.Module.Name",
        "files_affected": 3,
        "total_changes": 5,
        "files": [
          {"path": "lib/file.ex", "lines": [10, 25, 67]}
        ]
      }
    ]
  }
  ```
- JSON files stored in `test/projects/validation/results/` with naming pattern: `{project_name}_{timestamp}.json`
- Summary report shows per-project and aggregate statistics
- Summary identifies most frequently triggered rules across all projects
- Documentation explains configuration, execution, and result interpretation
- Process completes for all projects (or handles failures gracefully with error reporting)
