---
title: Add Test Coverage for Single Rules
description: Add dedicated tests for rules currently only tested via ElixirStyleGuideFormatter and integrate ex_coveralls to measure test coverage.
branch: feature/test-coverage-single-rules
---

## Overview

Add dedicated tests for rules that are currently only tested indirectly via `Green.Lexmag.ElixirStyleGuideFormatter`. Integrate `ex_coveralls` to measure and track test coverage, ensuring comprehensive testing of all 19 rules in the Green formatter.

## Tasks

- [x] Add ex_coveralls dependency to project
- [ ] Configure ex_coveralls with appropriate settings
- [ ] Identify rules missing dedicated tests
- [ ] Create test for `Green.Rules.Linting.NoNilElse`
- [ ] Create test for `Green.Rules.Linting.AvoidNeedlessPipelines`
- [ ] Run coverage analysis to identify any remaining gaps
- [ ] Verify all rules have >90% test coverage
- [ ] Update CI configuration to run coverage checks
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- [mix.exs](mix.exs) - Add ex_coveralls dependency
- [test/green/rules/linting/no_nil_else_test.exs](test/green/rules/linting/no_nil_else_test.exs) - Create test for NoNilElse rule
- [test/green/rules/linting/avoid_needless_pipelines_test.exs](test/green/rules/linting/avoid_needless_pipelines_test.exs) - Create test for AvoidNeedlessPipelines rule
- [lib/green/rules/linting/no_nil_else.ex](lib/green/rules/linting/no_nil_else.ex) - Rule to be tested
- [lib/green/rules/linting/avoid_needless_pipelines.ex](lib/green/rules/linting/avoid_needless_pipelines.ex) - Rule to be tested
- Existing test files in [test/green/rules/](test/green/rules/) for reference patterns

## Acceptance Criteria

- ex_coveralls is integrated and configured
- `NoNilElse` rule has dedicated test coverage including:
  - Basic transformation tests
  - Configuration tests (enabled/disabled)
  - Exception handling tests (except configuration)
  - Edge case coverage
- `AvoidNeedlessPipelines` rule has dedicated test coverage with similar test categories
- All 19 rules show in coverage report
- Overall test coverage for rules directory is >90%
- Coverage can be run via `mix coveralls` and `mix coveralls.html`
- Documentation includes instructions for running coverage analysis
