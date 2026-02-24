# Feature Comparison Grid

Status: [x]

## Description

Create a comprehensive feature comparison grid that lists all known Elixir style guide rules and indicates which style guides propose each rule. This will provide a complete overview of the style guide landscape without initially focusing on Green's implementation status.

## Technical Specifics

- Style guides to compare:
  - lexmag/elixir-style-guide (https://github.com/lexmag/elixir-style-guide) - Green's base
  - Official Elixir style guide (https://hexdocs.pm/elixir_style_guide/readme.html)
  - Credo style guide (https://github.com/rrrene/elixir-style-guide)
  - Christopher Adams' style guide (https://github.com/christopheradams/elixir_style_guide)
- Grid format: rows = rules, columns = style guides
- For each rule/guide intersection, indicate whether that guide proposes the rule
- Categorization: analyze how each guide categorizes rules; only use categories if there's near-consensus across guides, otherwise present as flat list
- Document all unique rules across all guides
- Add to documentation under docs/ folder

# Test Elixir Formatter Behavior Against Style Guide Rules

Status: [x]

## Description

Create a comprehensive test suite that validates which rules from the style guide comparison document are actually enforced by the official Elixir formatter (`mix format`). This will provide empirical data about formatter behavior and help identify gaps between documented rules and actual formatter implementation.

The comparison document currently has limited information about what the official Elixir formatter actually does - this testing infrastructure will address that gap by systematically testing formatter behavior against each rule.

## Technical Specifics

- Create a test Mix project under `test/projects/elixir_formatter/` to provide an isolated environment for running `mix format`
- For each rule marked with type "F" (Formatting) in [elixir-style-guide-comparison.md](docs/elixir-style-guide-comparison.md), create:
  - A "bad" example file that violates the rule
  - An "expected" file showing the corrected code
  - A test that runs `mix format` and verifies the transformation
  - If the formatter doesn't enforce a rule, write a negative test like `test "doesn't do X" ...` that verifies the code remains unchanged
- Test infrastructure:
  - Tag all tests with `@tag :elixir_formatter`
  - Configure `test_helper.exs` with `ExUnit.configure(exclude: [elixir_formatter: true])` so tests don't run by default
  - Tests can be run explicitly with `mix test --include elixir_formatter`
  - Programmatically invoke `mix format` on test files
  - Compare output against expected results
- Update [elixir-style-guide-comparison.md](docs/elixir-style-guide-comparison.md) with empirical results based on test outcomes
- Priority: Focus first on rules where the "Official Elixir" column has a checkmark, as these are claimed to be formatter-enforced
- Approximately ~45 formatting rules to test across categories: whitespace, indentation, parentheses, numeric literals, data structures, etc.

# Add Tests for Missing Lexmag Style Guide Rules

Status: [x]

## Description

The project currently has tests for 18 out of ~23 automatable Lexmag style guide rules. Add test coverage for the remaining 5 testable linting rules to ensure complete implementation of the Lexmag Elixir Style Guide.

## Technical Specifics

Missing tests for the following rules from [tmp/rules-lexmag.md](tmp/rules-lexmag.md):

1. **`anonymous-pipeline`** - Don't use anonymous functions in pipelines
   - Location: Linting > General
   - Should warn/transform: `pipeline |> (fn x -> x + 1 end).()`

2. **`boolean-operators`** - Use `||`, `&&`, `!` only for non-boolean checks (and/or/not for booleans)
   - Location: Linting > General
   - Should warn about: Using `||`/`&&` with boolean values instead of `or`/`and`

3. **`camelcase-modules`** - Use CamelCase for module names, keep acronyms uppercase
   - Location: Linting > Naming
   - Should warn about: `My_module`, `Mymodule` (incorrect cases)

4. **`predicate-funs-name`** - Predicate functions should have trailing `?`; guard-safe macros use `is_` prefix
   - Location: Linting > Naming
   - Should warn/transform: Functions returning booleans without `?` suffix

5. **`exception-message`** - Use non-capitalized error messages when raising (no trailing punctuation except Mix)
   - Location: Linting > Exceptions
   - Should warn about: `raise MyError, "This is wrong."` or `raise MyError, "this is wrong."`

Each test should follow the existing pattern in [test/green/lexmag/elixir_style_guide_formatter_test.exs](test/green/lexmag/elixir_style_guide_formatter_test.exs) with appropriate fixture files or examples.

# Validate Green Formatter Against Major Elixir Projects

Status: [x]

## Description

Create an automated testing system that checks out code from major Elixir projects and validates whether the Green formatter correctly identifies formatting issues according to lexmag's Elixir style guide. This will help ensure the formatter works properly on real-world codebases and identify both false positives (incorrectly flagging compliant code) and false negatives (missing actual issues).

## Technical Specifics

- Test against the following projects:
  - elixir-lang (monorepo - test each subproject separately, including Elixir core, ExUnit, Mix, IEx, Logger, etc.)
  - Phoenix
  - Phoenix LiveView
  - Hexpm
  - Nerves
  - Absinthe
  - Broadway
  - Credo

- Create a script/tool that:
  - Clones or checks out the selected projects
  - For elixir-lang, identifies and processes each subproject within the monorepo
  - Runs Green formatter against each project's codebase
  - Captures and categorizes any formatting changes or warnings
  - Reports statistics on:
    - Number of files processed
    - Number of changes proposed
    - Types of rules triggered
    - Files with no issues found

- Store test results as JSON for analysis and versioning
- Maintain a baseline/snapshot of results to track improvements over time
- Generate summary reports showing:
  - Which rules from lexmag's style guide are most frequently triggered in real codebases
  - Potential false positives that need investigation
  - Projects that are already compliant with lexmag's Elixir style guide
  - Per-project breakdown of results

# Add Per-Rule Configuration Support to All Green Rules

Status: [x]

## Description

Enable selective enabling/disabling of individual formatter rules via configuration in `.formatter.exs`. Currently, only 3 out of 19 rules support configuration (PreferPipelines, AvoidCaps, UseParenthesesWithZeroArityFunctions). This capability is a prerequisite for validating Green against major Elixir projects, where we need to test each rule independently to identify which rules trigger on real-world code.

## Technical Specifics

- Add configuration support to the remaining 16 rules:
  - Linting.AvoidNeedlessPipelines
  - Linting.NoAnonymousFunctionsInPipelines
  - Linting.NoUnlessWithElse
  - Linting.NoNilElse
  - Linting.TrueInCond
  - Linting.BooleanOperators
  - Linting.UseStringConcatenationWhenMatchingBinaries
  - Naming.AvoidOneLetterVariables
  - Naming.PredicateFunctions
  - Naming.UpperCamelCaseForModules
  - Modules.SortReferences
  - Modules.UseModulePseudoVariable
  - Structs.RemoveNilFromStructDefinition
  - Exceptions.UseErrorSuffix
  - Exceptions.LowercaseExceptionMessages
  - Exceptions.NoTrailingPunctuationInExceptionMessages

- Each rule should follow the pattern established by UseParenthesesWithZeroArityFunctions:
  - Add a `prepare_opts/1` function that uses `Options.set_value/3` to set default `enabled: true`
  - Check `opts[:green][rule_name][:enabled]` in the `apply/2` function
  - Return unchanged code if `enabled` is false
  - Rule name key should be snake_case version of the rule module name

- Configuration format in `.formatter.exs`:
  ```elixir
  [
    plugins: [Green.Lexmag.ElixirStyleGuideFormatter],
    green: [
      use_parentheses_with_zero_arity_functions: [enabled: false],
      prefer_pipelines: [enabled: false],
      avoid_caps: [enabled: false]
      # etc.
    ]
  ]
  ```

- Add tests to verify each rule can be selectively enabled/disabled
- Update each rule's module documentation to explain the configuration option
