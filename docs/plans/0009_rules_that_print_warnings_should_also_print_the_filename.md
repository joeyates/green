---
title: Rules that print warnings should also print the filename
description: Update all rules to pass opts to IO.warn so filenames are automatically included in warnings
branch: feature/add-filename-to-warnings
---

## Overview

Currently, some rules pass `[]` to `IO.warn/2` instead of `opts`. Since `opts` contains the `:file` key, passing it to `IO.warn/2` allows Elixir to automatically include the filename in warning output. This task ensures all rules consistently pass `opts` to their warning calls.

## Tasks

- [x] Update `Green.Rules.Linting.BooleanOperators` to pass `opts` through `do_apply` and to `IO.warn`
- [x] Update `Green.Rules.Linting.NoAnonymousFunctionsInPipelines` to pass `opts` through `do_apply` and to `IO.warn`
- [x] Update `Green.Rules.Exceptions.NoTrailingPunctuation` to pass `opts` through `do_apply` and to `IO.warn`
- [x] Update `Green.Rules.Naming.PredicateFunctions` to pass `opts` through `do_apply` and to `IO.warn`
- [x] Update `Green.Rules.Naming.UpperCamelCaseForModules` to pass `opts` through `do_apply` and to `IO.warn`
- [ ] Update `Green.Rules.Exceptions.UseErrorSuffix` to pass `opts` through `do_apply` and to `IO.warn`
- [ ] Verify all existing tests still pass
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- `lib/green/rules/linting/boolean_operators.ex`
- `lib/green/rules/linting/no_anonymous_functions_in_pipelines.ex`
- `lib/green/rules/exceptions/no_trailing_punctuation.ex`
- `lib/green/rules/naming/predicate_functions.ex`
- `lib/green/rules/naming/upper_camel_case_for_modules.ex`
- `lib/green/rules/exceptions/use_error_suffix.ex`

## Acceptance Criteria

- All rules that call `IO.warn` pass `opts` as the second parameter
- All `do_apply` functions that call `IO.warn` receive and use `opts`
- All existing tests pass
- Warning messages automatically include filenames when available
