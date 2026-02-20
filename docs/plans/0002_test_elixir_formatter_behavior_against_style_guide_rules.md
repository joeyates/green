---
title: Test Elixir Formatter Behavior Against Style Guide Rules
description: Create a comprehensive test suite that validates which rules from the style guide comparison document are actually enforced by the official Elixir formatter (`mix format`).
branch: feature/test-elixir-formatter-behavior
---

## Overview

This plan creates an isolated test infrastructure to empirically verify which of the ~45 formatting rules (marked "F" in the comparison document) are actually enforced by `mix format`. The results will update the comparison document with concrete data about formatter behavior, replacing assumptions with verified facts.

**Target Elixir Version:** 1.19.5

The test project will be configured for Elixir 1.19.5 to ensure consistent and reproducible formatter behavior.

## Tasks

- [x] Create test Mix project structure under `test/projects/elixir_formatter/` with mix.exs specifying Elixir 1.19.5 and basic configuration
- [x] Set up test infrastructure in main project to run formatter tests (test file with excluded tags, helper configuration)
- [x] Create test cases for Whitespace rules (~7 formatting rules)
- [ ] Create test cases for Indentation rules (~6 formatting rules)
- [ ] Create test cases for Numeric Literals rules (~2 formatting rules)
- [ ] Create test cases for Atoms and Strings rules (~2 formatting rules)
- [ ] Create test cases for Data Structures rules (~3 formatting rules)
- [ ] Create test cases for Control Flow rules (~1 formatting rule)
- [ ] Create test cases for Parentheses rules (~7 formatting rules)
- [ ] Create test cases for Layout rules (~2 formatting rules)
- [ ] Create test cases for Comments rules (~2 formatting rules)
- [ ] Document helper functions/utilities for running `mix format` and comparing outputs
- [ ] Review and consolidate test results to identify patterns in formatter behavior
- [ ] Update [elixir-style-guide-comparison.md](docs/elixir-style-guide-comparison.md) with empirical findings based on test outcomes
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- `test/projects/elixir_formatter/mix.exs` - Test project configuration (Elixir 1.19.5)
- `test/projects/elixir_formatter/.formatter.exs` - Formatter configuration for test project
- `test/elixir_formatter_test.exs` - Main test file with formatter behavior tests
- `test/test_helper.exs` - Update to configure tag exclusion
- `docs/elixir-style-guide-comparison.md` - Update with empirical results

## Acceptance Criteria

- Test project mix.exs specifies Elixir version 1.19.5
- Test infrastructure allows running `mix format` programmatically on test code samples
- All ~45 formatting rules marked "F" in the comparison document have corresponding test cases
- Tests are tagged with `@tag :elixir_formatter` and excluded by default via `test_helper.exs`
- Tests can be run explicitly with `mix test --include elixir_formatter`
- Each test clearly indicates whether the formatter enforces the rule (positive test) or doesn't (negative test)
- The comparison document is updated with columns or annotations showing which rules are actually formatter-enforced based on test results
- Documentation explains how to run the tests and interpret results
