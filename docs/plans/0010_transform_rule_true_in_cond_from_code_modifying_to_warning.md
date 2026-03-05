---
title: Transform rule `true_in_cond` from code-modifying to warning
description: Convert the `true_in_cond` rule from automatically transforming code to emitting warnings when the last clause of a `cond` does not have `true` as its condition.
branch: feature/true-in-cond-warning
---

## Overview

Currently, the `true_in_cond` rule automatically replaces non-`true` final clauses in `cond` statements with `true`. However, there are many possible forms that problematic code can take, making automatic correction unreliable. This plan transforms the rule to emit warnings instead, following the pattern established by other warning-based rules like `avoid_one_letter_variables` and `use_error_suffix`.

## Tasks

- [x] Update [lib/green/rules/linting/true_in_cond.ex](lib/green/rules/linting/true_in_cond.ex) to emit warnings using `IO.warn` instead of modifying the AST
- [x] Remove the "good" fixture file [test/fixtures/linting/true_in_cond.ex](test/fixtures/linting/true_in_cond.ex) (no longer needed since code won't be transformed)
- [ ] Rename [test/fixtures/linting/true_in_cond_bad.ex](test/fixtures/linting/true_in_cond_bad.ex) to `true_in_cond.ex` (convention for warning-based tests)
- [x] Update tests in [test/green/lexmag/elixir_style_guide_formatter_test.exs](test/green/lexmag/elixir_style_guide_formatter_test.exs) to check for warnings instead of code transformations
- [x] Create dedicated test file [test/green/rules/linting/true_in_cond_test.exs](test/green/rules/linting/true_in_cond_test.exs) following the pattern of [test/green/rules/exceptions/use_error_suffix_test.exs](test/green/rules/exceptions/use_error_suffix_test.exs)
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- [lib/green/rules/linting/true_in_cond.ex](lib/green/rules/linting/true_in_cond.ex) - Rule implementation
- [test/fixtures/linting/true_in_cond_bad.ex](test/fixtures/linting/true_in_cond_bad.ex) - Test fixture with problematic code
- [test/fixtures/linting/true_in_cond.ex](test/fixtures/linting/true_in_cond.ex) - Currently "good" fixture, to be removed
- [test/green/lexmag/elixir_style_guide_formatter_test.exs](test/green/lexmag/elixir_style_guide_formatter_test.exs) - Integration tests
- [test/green/rules/linting/true_in_cond_test.exs](test/green/rules/linting/true_in_cond_test.exs) - New dedicated test file

## Acceptance Criteria

- The rule no longer modifies code; it returns the original AST unchanged
- When a `cond` statement's final clause doesn't use `true`, a warning is emitted to stderr
- The warning includes the line number and relevant context
- The `except` configuration continues to work for both file-level and line-level exceptions
- The `enabled` configuration option continues to work
- Tests verify warning behavior using `ExUnit.CaptureIO`
- All checks pass (`mix format --check-formatted` and `mix test`)
