---
title: Add Per-File/Per-Line Exception Support to All Green Rules
description: Extend the `except: []` configuration pattern to all 17 remaining Green rules to provide fine-grained control over rule application at the file and line level.
branch: feature/per-file-per-line-exception-support
---

## Overview

Add support for the `except` configuration option to all Green rules, allowing users to selectively disable rules for specific files or specific lines within files. This feature is already implemented in `AvoidNeedlessPipelines` and `TrueInCond`, and needs to be extended to the remaining 17 rules following the same pattern.

The `except` configuration supports three formats:
- Disable for entire file: `"path/to/file.exs"`
- Disable for single line: `{"path/to/file.exs", 42}`
- Disable for multiple lines: `{"path/to/file.exs", [10, 20, 30]}`

## Tasks

- [x] Add except support to linting rules (5 rules):
  - `NoAnonymousFunctionsInPipelines`
  - `NoUnlessWithElse`
  - `NoNilElse`
  - `BooleanOperators`
  - `UseStringConcatenationWhenMatchingBinaries`
- [x] Add except support to `PreferPipelines` rule
- [x] Add except support to naming rules (3 rules):
  - `AvoidOneLetterVariables`
  - `PredicateFunctions`
  - `UpperCamelCaseForModules`
- [ ] Add except support to `AvoidCaps` rule
- [ ] Add except support to modules rules (2 rules):
  - `SortReferences`
  - `UseModulePseudoVariable`
- [ ] Add except support to `UseParenthesesWithZeroArityFunctions` rule
- [ ] Add except support to `RemoveNilFromStructDefinition` rule
- [ ] Add except support to exceptions rules (3 rules):
  - `UseErrorSuffix`
  - `LowercaseExceptionMessages`
  - `NoTrailingPunctuation`
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

Each rule file will follow the same implementation pattern:

**Linting Rules:**
- [lib/green/rules/linting/no_anonymous_functions_in_pipelines.ex](lib/green/rules/linting/no_anonymous_functions_in_pipelines.ex)
- [lib/green/rules/linting/no_unless_with_else.ex](lib/green/rules/linting/no_unless_with_else.ex)
- [lib/green/rules/linting/no_nil_else.ex](lib/green/rules/linting/no_nil_else.ex)
- [lib/green/rules/linting/boolean_operators.ex](lib/green/rules/linting/boolean_operators.ex)
- [lib/green/rules/linting/use_string_concatenation_when_matching_binaries.ex](lib/green/rules/linting/use_string_concatenation_when_matching_binaries.ex)
- [lib/green/rules/linting/prefer_pipelines.ex](lib/green/rules/linting/prefer_pipelines.ex)

**Naming Rules:**
- [lib/green/rules/naming/avoid_one_letter_variables.ex](lib/green/rules/naming/avoid_one_letter_variables.ex)
- [lib/green/rules/naming/predicate_functions.ex](lib/green/rules/naming/predicate_functions.ex)
- [lib/green/rules/naming/upper_camel_case_for_modules.ex](lib/green/rules/naming/upper_camel_case_for_modules.ex)
- [lib/green/rules/naming/avoid_caps.ex](lib/green/rules/naming/avoid_caps.ex)

**Module Rules:**
- [lib/green/rules/modules/sort_references.ex](lib/green/rules/modules/sort_references.ex)
- [lib/green/rules/modules/use_module_pseudo_variable.ex](lib/green/rules/modules/use_module_pseudo_variable.ex)

**Parentheses Rules:**
- [lib/green/rules/parentheses/use_parentheses_with_zero_arity_functions.ex](lib/green/rules/parentheses/use_parentheses_with_zero_arity_functions.ex)

**Struct Rules:**
- [lib/green/rules/structs/remove_nil_from_struct_definition.ex](lib/green/rules/structs/remove_nil_from_struct_definition.ex)

**Exception Rules:**
- [lib/green/rules/exceptions/use_error_suffix.ex](lib/green/rules/exceptions/use_error_suffix.ex)
- [lib/green/rules/exceptions/lowercase_exception_messages.ex](lib/green/rules/exceptions/lowercase_exception_messages.ex)
- [lib/green/rules/exceptions/no_trailing_punctuation.ex](lib/green/rules/exceptions/no_trailing_punctuation.ex)

**Reference implementations:**
- [lib/green/rules/linting/avoid_needless_pipelines.ex](lib/green/rules/linting/avoid_needless_pipelines.ex)
- [lib/green/rules/linting/true_in_cond.ex](lib/green/rules/linting/true_in_cond.ex)

## Acceptance Criteria

1. All 17 remaining rules have `@rule_name` module attribute defined
2. All rules call `Options.prepare_except(@rule_name)` in their `prepare_opts/1` function
3. All rules check `context[:line] in except_lines` before applying transformations
4. All rules' module documentation includes the `except` configuration examples
5. Configuration can disable rules for entire files, single lines, or multiple lines
6. Existing tests continue to pass
7. The implementation follows the same pattern as `AvoidNeedlessPipelines` and `TrueInCond`
