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

# Add Optional Report Export to Check Subcommands

Status: [x]

## Description

Add optional output format parameter to the `check` and `check <project>` subcommands in the validation system. Currently, validation results are only printed to stdout as they are generated. This enhancement would enable saving complete results as JSON or formatted text files after all checks complete. This also involves removing the dead `SummaryReporter` module which expects to load pre-existing JSON files from disk.

## Technical Specifics

- Remove `lib/green_validation/summary_reporter.ex` (dead code that loads JSON from disk)
- Create `lib/green_validation/report_writer.ex` to generate reports from `GreenValidation.Result` structs:
  - `write_json(result, output_path)` - Serialize result to JSON
  - `write_text(result, output_path)` - Format result as human-readable text
  - Text format should match current stdout output structure
- Modify `bin/validate` to accept `--output` switch:
  - `bin/validate check --output json` or `bin/validate check --output txt`
  - `bin/validate check phoenix --output json:[path]` or `bin/validate check phoenix --output txt:[path]`
  - When no `--output` flag provided, maintain current stdout behavior
  - Collect the `Result` struct after validation completes
  - Pass result to appropriate `ReportWriter` function based on format
- Update `HelpfulOptions` command definitions to support the `--output` switch
- Consider default output filenames with timestamps when no path specified (e.g., `validation_phoenix_20260301T120000.json`)
- Update `test/projects/validation/README.md` with new command examples
- Remove references to `SummaryReporter` from documentation

# Improve Type Annotations Across GreenValidation Codebase

Status: [x]

## Description

Add comprehensive type annotations to all modules in the GreenValidation library to improve type safety and code clarity. This includes adding @spec declarations to all public functions and using explicit struct matching in function parameters.

## Technical Specifics

- Directory: `test/projects/validation/lib/green_validation/`
- Modules to update:
  - `baseline_formatter.ex`
  - `green_installer.ex`
  - `installer/mix_exs.ex`
  - `output_parser.ex`
  - `project.ex`
  - `projects.ex`
  - `repo.ex`
  - `repos.ex`
  - `report_writer.ex`
  - `result.ex`
  - `rule_result.ex`
  - `rule_validator.ex`
  - `test_run.ex`

- Changes needed for each module:
  1. Add `@spec` annotations to all public functions
  2. Use explicit struct matching in function parameters:
     - Example: `def foo(%Project{} = project, ...)` instead of `def foo(project, ...)`
  3. Ensure struct type definitions include `@type t ::` declarations where appropriate
  4. Consider adding specs to significant private functions for internal documentation

- Pattern example:
  ```elixir
  @spec parse_output(Project.t(), atom(), String.t()) :: {:ok, RuleResult.t()}
  def parse_output(%Project{} = _project, rule, output) do
    # implementation
  end
  ```

# Add Per-File/Per-Line Exception Support to All Green Rules

Status: [x]

## Description

Extend the `except: []` configuration pattern (already implemented in `AvoidNeedlessPipelines` and `TrueInCond`) to all remaining Green rules. This allows users to selectively disable rules for specific files or specific lines within files, providing fine-grained control when certain code patterns are intentionally used.

The `except` configuration supports three formats:
- Disable for entire file: `"path/to/file.exs"`
- Disable for single line: `{"path/to/file.exs", 42}`
- Disable for multiple lines: `{"path/to/file.exs", [10, 20, 30]}`

## Technical Specifics

- Apply the `except` pattern to the remaining 17 rules:
  - `Linting.NoAnonymousFunctionsInPipelines`
  - `Linting.NoUnlessWithElse`
  - `Linting.NoNilElse`
  - `Linting.BooleanOperators`
  - `Linting.UseStringConcatenationWhenMatchingBinaries`
  - `Linting.PreferPipelines`
  - `Naming.AvoidOneLetterVariables`
  - `Naming.PredicateFunctions`
  - `Naming.UpperCamelCaseForModules`
  - `Naming.AvoidCaps`
  - `Modules.SortReferences`
  - `Modules.UseModulePseudoVariable`
  - `Parentheses.UseParenthesesWithZeroArityFunctions`
  - `Structs.RemoveNilFromStructDefinition`
  - `Exceptions.UseErrorSuffix`
  - `Exceptions.LowercaseExceptionMessages`
  - `Exceptions.NoTrailingPunctuationInExceptionMessages`

- Each rule should:
  - Add `@rule_name` module attribute (if not present)
  - Update `prepare_opts/1` to call `Options.prepare_except(@rule_name)`
  - Update `apply/2` to use `get_in(opts, [:green, @rule_name])` pattern instead of direct access
  - Update `do_apply` to accept and use `rule_opts[:except_lines]`
  - Check `context[:line] in except_lines` before applying transformations
  - Update module documentation with `except` configuration examples

- Implementation pattern (follow `avoid_needless_pipelines.ex` and `true_in_cond.ex`):
  ```elixir
  @rule_name :my_rule_name

  def apply({forms, comments}, opts) do
    opts = prepare_opts(opts)
    rule_opts = get_in(opts, [:green, @rule_name]) || []
    if rule_opts[:enabled] do
      do_apply({forms, comments}, rule_opts)
    else
      {forms, comments}
    end
  end

  defp do_apply({forms, comments}, rule_opts) do
    except_lines = rule_opts[:except_lines] || []
    # In transformation logic: if context[:line] in except_lines, skip
  end

  defp prepare_opts(opts) do
    opts
    |> Options.set_value(
      [@rule_name],
      &Keyword.put_new(&1 || [], :enabled, true)
    )
    |> Options.prepare_except(@rule_name)
  end
  ```

- Add `except` documentation to each rule's moduledoc, similar to:
  ```elixir
  @moduledoc \"\"\"
  This rule [description].

  ## Configuration

  This rule is enabled by default, but can be disabled globally in the configuration file.

  The rule can also be configured to ignore specific files, or specific lines in specific files.
  This is useful for cases where applying the rule would be problematic.

  In `.formatter.exs`:

  \`\`\`elixir
    green: [
      my_rule_name: [
        enabled: *true | false,
        except: [
          "path/to/file.exs",
          {"path/to/other_file.exs", 42},
          {"path/to/yet_another_file.exs", [10, 20, 30]}
        ]
      ]
    ]
  \`\`\`
  \"\"\"
  ```

# Rules that print warnings should also print the filename

Status: [x]

## Description

Currently, rules that print warnings only print the problematic code and the
line where it appears. Change this to print the filename too, when available.

# Transform rule `true_in_cond` from code-modifying to warning

Status: [x]

## Description

When the last clause of a `cond` does not have `true` as its condition, there are
many possible forms that the code can take. Instead of trying to correct the problem,
print a warning.

# Add Test Coverage for Single Rules

Status: [x]

## Description

Currently, some rules are only tested via their use in `Green.Lexmag.ElixirStyleGuideFormatter`. Add specific tests for these under `tests/green/rules`.

# Build a Changelog

Status: [x]

## Description

Create a `Changelog` file in the project root following the
[Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) format.
Use git history to identify version releases by tracking `@version` changes
in `mix.exs`. Treat commit `ee9f0b80` as the first release (0.1.1) with a
simple "First release" entry. Categorise commits between version bumps
using Keep a Changelog types (Added, Changed, Fixed, etc.).

Skip commits that do not change the library's behaviour.

Check test changes between commits to catch information about changes that are not described in commit messages.

## Technical Specifics

- File name: `Changelog` (in the project root).
- Format: [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/).
- Version releases are identified by commits that change `@version` in `mix.exs`.
- Commit `ee9f0b80` represents the first release (0.1.1) — use "First release" as its entry.
- Include an `[Unreleased]` section at the top.
