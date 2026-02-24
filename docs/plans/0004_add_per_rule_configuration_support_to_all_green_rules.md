---
title: Add Per-Rule Configuration Support to All Green Rules
description: Enable selective enabling/disabling of individual formatter rules via `.formatter.exs` configuration
branch: feature/per-rule-configuration
---

## Overview

Add configuration support to the remaining 16 Green rules that currently lack the ability to be enabled/disabled via `.formatter.exs`. This follows the established pattern used by `UseParenthesesWithZeroArityFunctions`, `AvoidCaps`, and `PreferPipelines`, and is a prerequisite for validating Green against major Elixir projects where individual rules need to be tested in isolation.

Rules fall into two categories:
- **AST-modifying rules**: Transform code structure (tested by verifying unchanged AST)
- **Warning-emitting rules**: Emit warnings to stderr (tested with `capture_io(:stderr)` to verify no warnings)

## Tasks

- [x] Add configuration support to `Linting.AvoidNeedlessPipelines` (AST-modifying)
- [x] Add configuration support to `Linting.NoAnonymousFunctionsInPipelines` (warning-emitting)
- [x] Add configuration support to `Linting.NoUnlessWithElse` (AST-modifying)
- [x] Add configuration support to `Linting.NoNilElse` (AST-modifying)
- [x] Add configuration support to `Linting.TrueInCond` (AST-modifying)
- [x] Add configuration support to `Linting.BooleanOperators` (warning-emitting)
- [x] Add configuration support to `Linting.UseStringConcatenationWhenMatchingBinaries` (AST-modifying)
- [x] Add configuration support to `Naming.AvoidOneLetterVariables` (warning-emitting)
- [x] Add configuration support to `Naming.PredicateFunctions` (warning-emitting)
- [x] Add configuration support to `Naming.UpperCamelCaseForModules` (warning-emitting)
- [x] Add configuration support to `Modules.SortReferences` (AST-modifying)
- [x] Add configuration support to `Modules.UseModulePseudoVariable` (AST-modifying)
- [ ] Add configuration support to `Structs.RemoveNilFromStructDefinition` (AST-modifying)
- [ ] Add configuration support to `Exceptions.UseErrorSuffix` (warning-emitting)
- [ ] Add configuration support to `Exceptions.LowercaseExceptionMessages` (warning-emitting)
- [ ] Add configuration support to `Exceptions.NoTrailingPunctuationInExceptionMessages` (warning-emitting)
- [ ] Update documentation for README or guides explaining per-rule configuration
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- [lib/green/rules/linting/avoid_needless_pipelines.ex](lib/green/rules/linting/avoid_needless_pipelines.ex)
- [lib/green/rules/linting/no_anonymous_functions_in_pipelines.ex](lib/green/rules/linting/no_anonymous_functions_in_pipelines.ex)
- [lib/green/rules/linting/no_unless_with_else.ex](lib/green/rules/linting/no_unless_with_else.ex)
- [lib/green/rules/linting/no_nil_else.ex](lib/green/rules/linting/no_nil_else.ex)
- [lib/green/rules/linting/true_in_cond.ex](lib/green/rules/linting/true_in_cond.ex)
- [lib/green/rules/linting/boolean_operators.ex](lib/green/rules/linting/boolean_operators.ex)
- [lib/green/rules/linting/use_string_concatenation_when_matching_binaries.ex](lib/green/rules/linting/use_string_concatenation_when_matching_binaries.ex)
- [lib/green/rules/naming/avoid_one_letter_variables.ex](lib/green/rules/naming/avoid_one_letter_variables.ex)
- [lib/green/rules/naming/predicate_functions.ex](lib/green/rules/naming/predicate_functions.ex)
- [lib/green/rules/naming/upper_camel_case_for_modules.ex](lib/green/rules/naming/upper_camel_case_for_modules.ex)
- [lib/green/rules/modules/sort_references.ex](lib/green/rules/modules/sort_references.ex)
- [lib/green/rules/modules/use_module_pseudo_variable.ex](lib/green/rules/modules/use_module_pseudo_variable.ex)
- [lib/green/rules/structs/remove_nil_from_struct_definition.ex](lib/green/rules/structs/remove_nil_from_struct_definition.ex)
- [lib/green/rules/exceptions/use_error_suffix.ex](lib/green/rules/exceptions/use_error_suffix.ex)
- [lib/green/rules/exceptions/lowercase_exception_messages.ex](lib/green/rules/exceptions/lowercase_exception_messages.ex)
- [lib/green/rules/exceptions/no_trailing_punctuation_in_exception_messages.ex](lib/green/rules/exceptions/no_trailing_punctuation_in_exception_messages.ex)
- Corresponding test files under [test/green/rules/](test/green/rules/)

## Acceptance Criteria

- All 16 rules implement the configuration pattern:
  - `prepare_opts/1` function that calls `Options.set_value/3` with `enabled: true` default
  - Check `opts[:green][rule_name][:enabled]` in `apply/2` function
  - Return unchanged AST when `enabled` is false
  - Rule name key is snake_case version of module name
- Each rule has a test verifying that setting `enabled: false` disables the rule:
  - **AST-modifying rules**: Verify "bad" code remains unchanged (AST comparison)
  - **Warning-emitting rules**: Use `capture_io(:stderr)` to verify no warnings are emitted
- Configuration follows the format:
  ```elixir
  [
    plugins: [Green.Lexmag.ElixirStyleGuideFormatter],
    green: [
      rule_name: [enabled: false]
    ]
  ]
  ```
- All existing tests continue to pass
- Module documentation for each rule explains the configuration option
