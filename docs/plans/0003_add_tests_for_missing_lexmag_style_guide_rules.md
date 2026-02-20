---
title: Add Tests for Missing Lexmag Style Guide Rules
description: Add test coverage for 5 missing testable linting rules from the Lexmag Elixir Style Guide to ensure complete test coverage (implementation of rules is separate).
branch: feature/add-missing-lexmag-tests
---

## Overview

The project currently has tests for 18 out of ~23 automatable Lexmag style guide rules in [test/green/lexmag/elixir_style_guide_formatter_test.exs](test/green/lexmag/elixir_style_guide_formatter_test.exs). This plan adds test coverage for the remaining 5 testable linting rules. Note: We're only adding tests here - some may fail because the rules aren't implemented yet, and that's expected.

## Tasks

- [ ] Add test for `anonymous-pipeline` rule (warn about anonymous functions in pipelines)
- [ ] Add test for `boolean-operators` rule (warn about `||`/`&&` with boolean values)
- [ ] Add test for `camelcase-modules` rule (warn about incorrect module name casing)
- [ ] Add test for `predicate-funs-name` rule (warn about boolean functions without `?` suffix)
- [ ] Add test for `exception-message` rule (warn about improperly formatted error messages)
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- [test/green/lexmag/elixir_style_guide_formatter_test.exs](test/green/lexmag/elixir_style_guide_formatter_test.exs) - Add new test cases
- [test/fixtures/linting/](test/fixtures/linting/) - Create fixture files for rules requiring transformation
- [test/fixtures/naming/](test/fixtures/naming/) - Create fixture files for naming-related rules
- [test/fixtures/exceptions/](test/fixtures/exceptions/) - Create fixture files for exception rules
- [tmp/rules-lexmag.md](tmp/rules-lexmag.md) - Reference for rule specifications

## Acceptance Criteria

- All 5 missing rules have corresponding tests in the test file
- Each test follows the existing pattern (using `@tag fixture_pair:` or `@tag example:` as appropriate)
- Fixture files are created in appropriate subdirectories following naming conventions
- Tests are properly structured and would pass if the rules were implemented
- It's acceptable for tests to fail if the underlying rules aren't yet implemented - we're documenting expected behavior
- Test coverage for Lexmag rules is complete (23/23 testable rules covered by tests)
