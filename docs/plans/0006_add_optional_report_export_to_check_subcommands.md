---
title: Add Optional Report Export to Check Subcommands
description: Add optional --format switch to save validation results as JSON or text files
branch: feature/add-optional-report-export
---

## Overview

Currently, validation results are printed to stdout as they're generated. This enhancement will add a `--format` option to save complete results as JSON or formatted text files after validation completes. This also involves removing the dead `SummaryReporter` module which expects to load pre-existing JSON files from disk.

## Technical Specifics

The HelpfulOptions command definition for the `--format` switch should follow this pattern:

```elixir
%{
  commands: ["check"], 
  description: "Check all projects", 
  switches: [
    format: %{type: :string, description: "Output format ('text'|'json')"}
  ]
}
```

Apply the same switch definition to both the `["check"]` and `["check", :project]` command configurations.

## Tasks

- [ ] Remove dead `SummaryReporter` module and its references
- [ ] Create `ReportWriter` module with JSON and text export functions
- [ ] Add `--format` switch to "check" command definitions using HelpfulOptions format
- [ ] Refactor `check_project/1` to build and return `Result` struct instead of only printing
- [ ] Update CLI `run/1` functions to handle `--format` switch and call `ReportWriter`  
- [ ] Generate default timestamped output filenames when format is specified
- [ ] Add tests for `ReportWriter` module
- [ ] Update validation system README with new command examples
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- `test/projects/validation/bin/validate` - CLI entry point, needs `--format` switch handling
- `test/projects/validation/lib/green_validation/summary_reporter.ex` - To be removed (dead code)
- `test/projects/validation/lib/green_validation/report_writer.ex` - New module to create
- `test/projects/validation/lib/green_validation/result.ex` - Result struct that needs to be built and returned
- `test/projects/validation/lib/green_validation/rule_validator.ex` - Returns RuleResult list
- `test/projects/validation/lib/green_validation/test_run.ex` - Metadata for test run
- `test/projects/validation/test/green_validation/report_writer_test.exs` - New test file to create
- `test/projects/validation/README.md` - Documentation to update

## Acceptance Criteria

- `SummaryReporter` module is removed from the codebase
- `ReportWriter` module exists with `write_json/2` and `write_text/2` functions
- Text format matches current stdout structure
- JSON format contains complete `Result` struct serialization
- `bin/validate check --format json` saves results to timestamped file (e.g., `validation_all_20260302T143022.json`)
- `bin/validate check --format text` saves results as formatted text with timestamp
- `bin/validate check phoenix --format json` saves to timestamped file with project name (e.g., `validation_phoenix_20260302T143022.json`)
- `bin/validate check phoenix --format text` saves formatted text with project name
- When no `--format` flag is provided, behavior remains unchanged (stdout only)
- Commands still print progress information to stdout even when using `--format`
- Tests verify both JSON and text export functions work correctly
- README includes examples of the new `--format` option
- All validation tests pass
