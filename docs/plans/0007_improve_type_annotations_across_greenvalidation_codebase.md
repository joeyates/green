---
title: Improve Type Annotations Across GreenValidation Codebase
description: Add comprehensive type annotations to all modules in the GreenValidation library to improve type safety and code clarity.
branch: chore/improve-type-annotations
---

## Overview

Add comprehensive type annotations to all modules in the GreenValidation library. Currently, the codebase has inconsistent type coverage - some modules have `@type` definitions and a few functions have `@spec` annotations, but most public functions lack specs. This plan will systematically add `@spec` annotations to all public functions and ensure consistent use of explicit struct matching in function parameters for improved type safety and code clarity.

## Tasks

- [ ] Add `@spec` annotations and explicit struct matching to [baseline_formatter.ex](test/projects/validation/lib/green_validation/baseline_formatter.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [green_installer.ex](test/projects/validation/lib/green_validation/green_installer.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [installer/mix_exs.ex](test/projects/validation/lib/green_validation/installer/mix_exs.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [output_parser.ex](test/projects/validation/lib/green_validation/output_parser.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [project.ex](test/projects/validation/lib/green_validation/project.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [projects.ex](test/projects/validation/lib/green_validation/projects.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [repo.ex](test/projects/validation/lib/green_validation/repo.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [repos.ex](test/projects/validation/lib/green_validation/repos.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [report_writer.ex](test/projects/validation/lib/green_validation/report_writer.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [result.ex](test/projects/validation/lib/green_validation/result.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [rule_result.ex](test/projects/validation/lib/green_validation/rule_result.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [rule_validator.ex](test/projects/validation/lib/green_validation/rule_validator.ex)
- [ ] Add `@spec` annotations and explicit struct matching to [test_run.ex](test/projects/validation/lib/green_validation/test_run.ex)
- [ ] Verify all struct modules have `@type t ::` declarations where appropriate
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- [test/projects/validation/lib/green_validation/baseline_formatter.ex](test/projects/validation/lib/green_validation/baseline_formatter.ex)
- [test/projects/validation/lib/green_validation/green_installer.ex](test/projects/validation/lib/green_validation/green_installer.ex)
- [test/projects/validation/lib/green_validation/installer/mix_exs.ex](test/projects/validation/lib/green_validation/installer/mix_exs.ex)
- [test/projects/validation/lib/green_validation/output_parser.ex](test/projects/validation/lib/green_validation/output_parser.ex)
- [test/projects/validation/lib/green_validation/project.ex](test/projects/validation/lib/green_validation/project.ex)
- [test/projects/validation/lib/green_validation/projects.ex](test/projects/validation/lib/green_validation/projects.ex)
- [test/projects/validation/lib/green_validation/repo.ex](test/projects/validation/lib/green_validation/repo.ex)
- [test/projects/validation/lib/green_validation/repos.ex](test/projects/validation/lib/green_validation/repos.ex)
- [test/projects/validation/lib/green_validation/report_writer.ex](test/projects/validation/lib/green_validation/report_writer.ex)
- [test/projects/validation/lib/green_validation/result.ex](test/projects/validation/lib/green_validation/result.ex)
- [test/projects/validation/lib/green_validation/rule_result.ex](test/projects/validation/lib/green_validation/rule_result.ex)
- [test/projects/validation/lib/green_validation/rule_validator.ex](test/projects/validation/lib/green_validation/rule_validator.ex)
- [test/projects/validation/lib/green_validation/test_run.ex](test/projects/validation/lib/green_validation/test_run.ex)

## Acceptance Criteria

- All public functions in the GreenValidation codebase have `@spec` annotations
- Function parameters that expect structs use explicit struct matching (e.g., `%Project{} = project`)
- All struct modules have proper `@type t ::` declarations
- No Dialyzer warnings are introduced
- Existing tests continue to pass
