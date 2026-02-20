# Elixir Style Guide Comparison

A comprehensive comparison of style guide rules across four major Elixir style guides.

**Last Updated**: February 2026

> **📊 Empirical Formatter Testing**: See [Elixir Formatter Test Results](elixir-formatter-test-results.md) for empirical data on which rules marked "F" (Formatting) are actually enforced by the Elixir 1.19.5 formatter. Testing shows **28 rules are enforced** and **6 rules are not enforced** by `mix format`.

---

## Introduction

This document compares style and formatting rules from four authoritative Elixir style guides. It helps developers understand where there is consensus across the community and where different approaches exist.

## The Guides

1. **[Official Elixir](https://hexdocs.pm/elixir/Code.html#format_string!/2)** - Code Formatter Documentation (elixir-lang.org)
   - Focus: Formatter behavior and design principles
   - Approach: Descriptive (explains what formatter does)

2. **[lexmag](https://github.com/lexmag/elixir-style-guide)** - Elixir Style Guide by Aleksei Magusev
   - Focus: Closest to Elixir core team conventions
   - Approach: Prescriptive, separates automated (formatting) from manual (linting)

3. **[credo](https://github.com/rrrene/elixir-style-guide)** - Credo's Elixir Style Guide by René Föhring
   - Focus: Basis for Credo static analysis tool
   - Approach: Organized by analysis type (readability, documentation, refactoring, design, pitfalls)

4. **[christopheradams](https://github.com/christopheradams/elixir_style_guide)** - The Elixir Style Guide by Christopher Adams
   - Focus: Most comprehensive community guide
   - Approach: Feature-based organization with extensive examples

## How to Use This Document

- **✓** indicates the guide explicitly covers this rule (click to view source)
- **—** indicates the guide does not explicitly cover this rule
- Rules are organized by topic for easy scanning
- Type codes indicate the nature of each rule (see legend below)

### Type Codes

- **F** = Formatting (automated by formatter) - *See [test results](elixir-formatter-test-results.md) for which F rules are empirically verified as enforced*
- **S** = Style (manual adherence)
- **B** = Best Practice
- **P** = Pitfall/Warning
- **T** = Testing

> **Note on "F" (Formatting) Rules**: While many rules are marked as "F" indicating they could be automated, empirical testing with Elixir 1.19.5 shows that not all "F" rules are actually enforced by `mix format`. See the [Elixir Formatter Test Results](elixir-formatter-test-results.md) document for detailed findings on which specific rules are enforced versus left to developer discretion.

---

## Comparison Matrix

### Naming Conventions

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Snake case for atoms/functions/variables | Use `snake_case` for atoms, functions, variables, and module attributes | S | — | [✓](https://github.com/lexmag/elixir-style-guide#snake-case-atoms-funs-vars-attrs) | [✓](https://github.com/rrrene/elixir-style-guide#snake-case-attributes-functions-macros-vars) | [✓](https://github.com/christopheradams/elixir_style_guide#snake-case) |
| CamelCase for modules | Use `CamelCase` for module names; keep acronyms uppercase | S | — | [✓](https://github.com/lexmag/elixir-style-guide#camelcase-modules) | [✓](https://github.com/rrrene/elixir-style-guide#camelcase-modules) | [✓](https://github.com/christopheradams/elixir_style_guide#camel-case) |
| Predicate functions end with ? | Predicate functions (returning boolean) should end in `?` | S | — | [✓](https://github.com/lexmag/elixir-style-guide#predicate-funs-name) | [✓](https://github.com/rrrene/elixir-style-guide#predicates) | [✓](https://github.com/christopheradams/elixir_style_guide#predicate-function-trailing-question-mark) |
| Guard macros use is_ prefix | Guard-safe boolean macros should use `is_` prefix (not `?`) | S | — | [✓](https://github.com/lexmag/elixir-style-guide#predicate-funs-name) | [✓](https://github.com/rrrene/elixir-style-guide#predicates) | [✓](https://github.com/christopheradams/elixir_style_guide#predicate-function-is-prefix) |
| Snake case for files/directories | Use `snake_case` for file and directory names | S | — | [✓](https://github.com/lexmag/elixir-style-guide#snake-case-dirs-files) | — | [✓](https://github.com/christopheradams/elixir_style_guide#underscored-filenames) |
| Avoid one-letter variables | Avoid using one-letter variable names | S | — | [✓](https://github.com/lexmag/elixir-style-guide#one-letter-var) | — | — |
| Private functions naming | Don't name private functions same as public; avoid `def name`/`defp do_name` | B | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#private-functions-with-same-name-as-public) |

### Whitespace

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| No trailing whitespace | Avoid trailing whitespace at end of lines | F | — | [✓](https://github.com/lexmag/elixir-style-guide#no-trailing-whitespaces) | [✓](https://github.com/rrrene/elixir-style-guide#no-trailing-whitespace) | [✓](https://github.com/christopheradams/elixir_style_guide#trailing-whitespace) |
| Newline at EOF | End each file with a newline | F | [✓](https://hexdocs.pm/elixir/Code.html) | [✓](https://github.com/lexmag/elixir-style-guide#newline-eof) | [✓](https://github.com/rrrene/elixir-style-guide#newline-eof) | [✓](https://github.com/christopheradams/elixir_style_guide#newline-eof) |
| Unix line endings | Use Unix-style line endings (`\n`) | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | [✓](https://github.com/rrrene/elixir-style-guide#line-endings) | [✓](https://github.com/christopheradams/elixir_style_guide#line-endings) |
| Two-space indentation | Use two-space soft-tabs for indentation (no hard tabs) | F | — | [✓](https://github.com/lexmag/elixir-style-guide#spaces-indentation) | [✓](https://github.com/rrrene/elixir-style-guide#spaces-indentation) | — |
| Spaces around operators | Use spaces around operators and after commas, colons, semicolons | F | — | [✓](https://github.com/lexmag/elixir-style-guide#spaces-in-code) | [✓](https://github.com/rrrene/elixir-style-guide#spaces-operators) | [✓](https://github.com/christopheradams/elixir_style_guide#spaces) |
| No spaces around matched pairs | Don't put spaces around matched pairs (brackets, braces, parentheses) | F | — | [✓](https://github.com/lexmag/elixir-style-guide#spaces-in-code) | [✓](https://github.com/rrrene/elixir-style-guide#spaces-braces) | [✓](https://github.com/christopheradams/elixir_style_guide#spaces) |
| Space after comment # | Use one space between `#` and comment text | F | [✓](https://hexdocs.pm/elixir/Code.html) | [✓](https://github.com/lexmag/elixir-style-guide#leading-space-comment) | — | [✓](https://github.com/christopheradams/elixir_style_guide#comment-leading-spaces) |
| Space before -> in 0-arity funs | Always use space before `->` in 0-arity anonymous functions | F | — | [✓](https://github.com/lexmag/elixir-style-guide#space-before-anonymous-fun-arrow) | — | — |
| Spaces around default args | Use spaces around default arguments `\\` definition | F | — | [✓](https://github.com/lexmag/elixir-style-guide#default-arguments) | — | — |
| No spaces in bitstring options | Don't put spaces around segment options in bitstrings | F | — | [✓](https://github.com/lexmag/elixir-style-guide#bitstring-segment-options) | — | — |
| No spaces after unary operators | No spaces after unary operators and inside range literals (except `not`) | F | — | [✓](https://github.com/lexmag/elixir-style-guide#no-spaces-in-code) | — | [✓](https://github.com/christopheradams/elixir_style_guide#no-spaces) |
| Blank lines between defs | Use blank lines between `def`s to break into logical paragraphs | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#def-spacing) |
| No blank line after defmodule | Don't put blank line after `defmodule` | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#defmodule-spacing) |
| Blank after multiline assignment | Add blank line after multiline assignment as visual cue | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#add-blank-line-after-multiline-assignment) |
| Vertical space for readability | Use vertical white-space to improve readability | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#vertical-space) | — |
| Group function definitions | Group same function with different arities; separate different functions | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#group-function-definitions) | — |

### Line Length

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Line length limit | Limit lines to specific character count (80-98 chars) | S | [✓](https://hexdocs.pm/elixir/Code.html) | — | [✓](https://github.com/rrrene/elixir-style-guide#character-per-line-limit) | [✓](https://github.com/christopheradams/elixir_style_guide#line-length) |
| Comment line length | Limit comment lines to 100 characters | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#comment-line-length) |
| Line length best effort | `:line_length` indicates when to break but isn't guaranteed | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | — | — |
| Manual string breaking | Long strings must be manually broken with `<>` concatenation | B | [✓](https://hexdocs.pm/elixir/Code.html) | — | — | — |

### Indentation

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Binary operator indentation | Indent right-hand side one level more when on different lines (except `when`, `\|>`) | F | — | [✓](https://github.com/lexmag/elixir-style-guide#binary-ops-indentation) | — | — |
| Pipeline indentation | Use single level of indentation for multi-line pipelines | F | — | [✓](https://github.com/lexmag/elixir-style-guide#pipeline-indentation) | — | [✓](https://github.com/christopheradams/elixir_style_guide#pipe-operator) |
| With clause indentation | Indent and align successive `with` clauses | F | — | [✓](https://github.com/lexmag/elixir-style-guide#with-indentation) | — | [✓](https://github.com/christopheradams/elixir_style_guide#with-clauses) |
| With multiline syntax | Use multiline syntax if `with` has >1 line body or `else` clause | S | — | [✓](https://github.com/lexmag/elixir-style-guide#with-indentation) | — | [✓](https://github.com/christopheradams/elixir_style_guide#with-else) |
| For indentation | Use specific indentation for `for` special form | F | — | [✓](https://github.com/lexmag/elixir-style-guide#for-indentation) | — | — |
| Avoid expression alignment | Avoid aligning expression groups vertically | F | — | [✓](https://github.com/lexmag/elixir-style-guide#expression-group-alignment) | — | — |
| Multiline assignment indentation | Begin multiline expression assignment on new line | S | — | [✓](https://github.com/lexmag/elixir-style-guide#multi-line-expr-assignment) | [✓](https://github.com/rrrene/elixir-style-guide#multi-line-call) | — |

### Numeric Literals

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Underscores in large numbers | Add underscores to large numeric literals for readability (6+ digits) | F | [✓](https://hexdocs.pm/elixir/Code.html) | [✓](https://github.com/lexmag/elixir-style-guide#underscores-in-numerics) | [✓](https://github.com/rrrene/elixir-style-guide#underscores-in-numerics) | — |
| Uppercase hex literals | Use uppercase letters for hex literals | F | — | [✓](https://github.com/lexmag/elixir-style-guide#hex-literals) | — | — |

### Atoms and Strings

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Double quotes for atoms | Use double quotes (not single) for quoted atoms | F | — | [✓](https://github.com/lexmag/elixir-style-guide#quotes-around-atoms) | — | — |
| String delimiter preservation | Strings, charlists, atoms, sigils kept as-is; delimiter choice respected | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | — | — |
| Sigil usage | Use sigils sensibly, not dogmatically | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#sigils) | — |
| Regex sigil preference | Use `~r//` as go-to sigil for regexes (most readable) | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#regex-sigils) | — |

### Data Structures

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| No trailing comma | Don't use trailing comma on last element of multiline collections | F | — | [✓](https://github.com/lexmag/elixir-style-guide#trailing-comma) | — | — |
| Multiline data structure formatting | If collection spans multiple lines, put each element and brackets on own lines | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#multiline-enums) |
| Multiline assignment bracket placement | Keep opening bracket on same line as assignment for multiline collections | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#multiline-list-assign) |
| Keyword list syntax | Always use special `key: value` syntax for keyword lists | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#keyword-list-syntax) |
| Keyword list brackets | Omit square brackets from keyword lists when optional | F | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#keyword-list-brackets) |
| Map key syntax (atoms) | Use shorthand `:key` syntax for maps when all keys are atoms | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#map-key-atom) |
| Map key syntax (mixed) | Use verbose `=>` syntax for maps if any key is not atom | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#map-key-arrow) |

### Control Flow

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Favor pipeline operator | Use `\|>` to chain function calls together | B | — | [✓](https://github.com/lexmag/elixir-style-guide#pipeline-operator) | — | [✓](https://github.com/christopheradams/elixir_style_guide#pipe-operator) |
| Avoid needless pipelines | Avoid using pipe operator for single function calls | B | — | [✓](https://github.com/lexmag/elixir-style-guide#needless-pipeline) | — | [✓](https://github.com/christopheradams/elixir_style_guide#avoid-single-pipelines) |
| No anonymous funs in pipelines | Don't use anonymous functions in pipelines | B | — | [✓](https://github.com/lexmag/elixir-style-guide#anonymous-pipeline) | — | — |
| Start pipelines with bare values | Start pipe chains with "pure" value rather than function call | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#pipe-chains) | [✓](https://github.com/christopheradams/elixir_style_guide#bare-variables) |
| Never unless with else | Never use `unless` with `else`; rewrite with `if` (positive case first) | B | — | [✓](https://github.com/lexmag/elixir-style-guide#no-else-with-unless) | [✓](https://github.com/rrrene/elixir-style-guide#no-unless-with-else) | [✓](https://github.com/christopheradams/elixir_style_guide#unless-with-else) |
| Avoid unless with negation | Never use `unless` with negated expression; use `if` | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#avoid-double-negations) | — |
| Omit nil else clause | Omit `else` clause if it would return `nil` | B | — | [✓](https://github.com/lexmag/elixir-style-guide#no-nil-else) | — | — |
| Use true in cond | Use `true` as final always-matching clause in `cond` | B | — | [✓](https://github.com/lexmag/elixir-style-guide#true-in-cond) | — | [✓](https://github.com/christopheradams/elixir_style_guide#true-as-last-condition) |
| Boolean operators | Use `\|\|`, `&&`, `!` only for non-boolean checks; use `and`, `or`, `not` for booleans | B | — | [✓](https://github.com/lexmag/elixir-style-guide#boolean-operators) | — | — |
| Single-line if/unless syntax | Use `do:` for single line `if`/`unless` statements | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#do-with-single-line-if-unless) |
| No nested conditionals | Never nest `if`/`unless`/`case` more than 1 time | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#no-nested-conditionals) | — |
| Multiline case clauses | If any case/cond clause needs >1 line, use multiline syntax for all | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#multiline-case-clauses) |
| do/end vs :do choice | Choice between `:do` keyword and `do`-`end` blocks left to user | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | — | — |

### Parentheses

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Zero-arity function parens | Always use parentheses for zero-arity function calls | F | — | [✓](https://github.com/lexmag/elixir-style-guide#zero-arity-parens) | — | [✓](https://github.com/christopheradams/elixir_style_guide#parentheses-and-functions-with-zero-arity) |
| Parens in function definitions | Use parentheses in `def`/`defp`/`defmacro` when function has parameters | F | — | [✓](https://github.com/lexmag/elixir-style-guide#fun-parens) | [✓](https://github.com/rrrene/elixir-style-guide#function-parens) | [✓](https://github.com/christopheradams/elixir_style_guide#fun-def-parentheses) |
| Parens in function calls | Use parentheses when calling functions with arguments | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | [✓](https://github.com/rrrene/elixir-style-guide#function-calling-parens) | [✓](https://github.com/christopheradams/elixir_style_guide#function-calls-and-parentheses) |
| Parens in pipelines | Use parentheses for functions in pipe chains | F | — | [✓](https://github.com/lexmag/elixir-style-guide#zero-arity-parens) | — | [✓](https://github.com/christopheradams/elixir_style_guide#parentheses-pipe-operator) |
| No parens for anonymous fun args | Never wrap arguments of anonymous functions in parentheses | F | — | [✓](https://github.com/lexmag/elixir-style-guide#anonymous-fun-parens) | — | — |
| No parens for macros | Don't use parentheses when calling macros | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#macro-parens) | — |
| No parens for if/unless condition | Never use parentheses around condition of `if`/`unless` | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#conditional-parens) | — |
| No space between function and paren | Never put space between function name and opening parenthesis | F | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#function-names-with-parentheses) |
| Parens for zero-arity types | Always use parens on zero-arity types in typespecs | F | — | [✓](https://github.com/lexmag/elixir-style-guide#parens-in-zero-arity-types) | — | — |
| Locals without parens config | Use `:locals_without_parens` config for local calls | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | — | — |

### Layout

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| No semicolons | Use one expression per line; don't use `;` to separate statements | F | — | [✓](https://github.com/lexmag/elixir-style-guide#no-semicolon) | [✓](https://github.com/rrrene/elixir-style-guide#semicolon-between-statements) | — |
| Binary operators at line end | Keep binary operators at end of line (except `\|>` at beginning) | F | — | [✓](https://github.com/lexmag/elixir-style-guide#binary-operators-at-eols) | — | — |
| Long do: on new line | If function head and `do:` too long, put `do:` on new line indented | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#long-dos) |
| Single-line defs grouping | Run single-line `def`s for same function together | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#single-line-defs) |
| No single-line with multiline defs | If >1 multiline `def`, don't use single-line `def`s | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#multiple-function-defs) |

### Modules

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Use __MODULE__ | Use `__MODULE__` pseudo-variable to reference current module | B | — | [✓](https://github.com/lexmag/elixir-style-guide#current-module-reference) | [✓](https://github.com/rrrene/elixir-style-guide#reference-current-module) | [✓](https://github.com/christopheradams/elixir_style_guide#module-pseudo-variable) |
| Module directive ordering | Use consistent ordering for directives (use/import/alias/require) | S | — | [✓](https://github.com/lexmag/elixir-style-guide#module-layout) | — | [✓](https://github.com/christopheradams/elixir_style_guide#module-attribute-ordering) |
| Alias modules in applications | When developing apps, alias all used modules | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#alias-modules) | — |
| Alias self-referencing modules | Set up alias for prettier module self-reference if desired | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#alias-self-referencing-modules) |
| Avoid repetitive module names | Avoid repeating fragments in module names and namespaces | B | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#repetitive-module-names) |
| One module per file | Use one module per file (unless internal helper) | B | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#one-module-per-file) |
| Module name as directory nesting | Represent each nesting level as directory | B | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#module-name-nesting) |

### Exceptions

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Exception names end with Error | Make exception names end with `Error` suffix | S | — | [✓](https://github.com/lexmag/elixir-style-guide#exception-naming) | [✓](https://github.com/rrrene/elixir-style-guide#exception-naming) | [✓](https://github.com/christopheradams/elixir_style_guide#exception-names) |
| Lowercase error messages | Use lowercase error messages when raising; no trailing punctuation | S | — | [✓](https://github.com/lexmag/elixir-style-guide#exception-message) | — | [✓](https://github.com/christopheradams/elixir_style_guide#lowercase-error-messages) |

### Structs

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Omit nil in defstruct | Don't explicitly specify `nil` for struct fields (use atom list) | S | — | [✓](https://github.com/lexmag/elixir-style-guide#defstruct-fields-default) | — | [✓](https://github.com/christopheradams/elixir_style_guide#nil-struct-field-defaults) |
| Omit defstruct brackets | Omit square brackets when `defstruct` argument is keyword list | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#struct-def-brackets) |
| Multiline struct formatting | If struct spans multiple lines, put each element on own line | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#multiline-structs) |

### Regular Expressions

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Prefer pattern matching over regex | Use pattern matching and String module before resorting to regex | B | — | [✓](https://github.com/lexmag/elixir-style-guide#pattern-matching-over-regexp) | — | — |
| Non-capturing groups | Use non-capturing groups when not using captured result | B | — | [✓](https://github.com/lexmag/elixir-style-guide#non-capturing-regexp) | — | — |
| Regex anchors for whole string | Use `\A` and `\z` to match whole string (not `^`/`$` which match lines) | B | — | [✓](https://github.com/lexmag/elixir-style-guide#caret-and-dollar-regexp) | [✓](https://github.com/rrrene/elixir-style-guide#caret-and-dollar-regex) | — |

### Documentation

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Always include @moduledoc | Always include `@moduledoc` (or `@moduledoc false` if not documenting) | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#doc-false) | [✓](https://github.com/christopheradams/elixir_style_guide#moduledocs) |
| @moduledoc spacing | Add blank line after `@moduledoc` | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#doc-style) | [✓](https://github.com/christopheradams/elixir_style_guide#moduledoc-spacing) |
| @moduledoc immediately after defmodule | Place `@moduledoc` right after `defmodule` | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#moduledocs) |
| No blank between @doc and function | Don't put blank line between `@doc` and function | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#doc-style) | — |
| Use heredocs with markdown | Use heredocs with markdown for documentation | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#heredocs) |
| Use ExDoc | Use ExDoc for documentation generation | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#exdoc) | — |
| Documentation philosophy | See documentation in positive light, not as chore | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#documentation) | — |

### Comments

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Use comments wisely | Use comments only for important information; prefer expressive code | B | — | [✓](https://github.com/lexmag/elixir-style-guide#critical-comments) | [✓](https://github.com/rrrene/elixir-style-guide#doc-comments) | [✓](https://github.com/christopheradams/elixir_style_guide#expressive-code) |
| Avoid superfluous comments | Don't state the obvious in comments | B | — | [✓](https://github.com/lexmag/elixir-style-guide#no-superfluous-comments) | — | — |
| Comments above code | Place comments above the line they comment on | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#comments-above-line) |
| Comment grammar | Capitalize comments longer than a word; use punctuation for sentences | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#comment-grammar) |
| Long comments on own line | Put longer descriptive comments on own line | S | — | — | [✓](https://github.com/rrrene/elixir-style-guide#doc-comments-on-own-lines) | — |
| Trailing comments extracted | Trailing comments moved to previous line by formatter | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | — | — |
| Comment operator limitations | Comments around operators moved before operator usage | F | [✓](https://hexdocs.pm/elixir/Code.html) | — | — | — |

### Comment Annotations

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Use TODO annotations | Use `TODO:` to note planned changes or missing features | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#todo) | [✓](https://github.com/christopheradams/elixir_style_guide#todo-notes) |
| Use FIXME annotations | Use `FIXME:` to note bugs or broken code | B | — | — | [✓](https://github.com/rrrene/elixir-style-guide#fixme) | [✓](https://github.com/christopheradams/elixir_style_guide#fixme-notes) |
| Use OPTIMIZE annotations | Use `OPTIMIZE:` to note slow/inefficient code | B | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#optimize-notes) |
| Use HACK annotations | Use `HACK:` to note code smells or questionable practices | B | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#hack-notes) |
| Use REVIEW annotations | Use `REVIEW:` to note code needing confirmation | B | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#review-notes) |
| Annotation format | Uppercase keyword, colon, space, then note | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#annotation-keyword) |
| Annotations above code | Write annotations on line immediately above relevant code | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#annotations) |

### Typespecs

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| @typedoc and @type together | Place `@typedoc` and `@type` together, separated by blank line between pairs | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#typedocs) |
| Multiline union types | If union type too long, put each part on separate line | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#union-types) |
| Main type named t | Name main type for module `t` (e.g., for struct) | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#naming-main-types) |
| @spec placement | Place `@spec` right before function, after `@doc`, no blank line | S | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#spec-spacing) |

### Strings and Binaries

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Use <> for string matching | Use `<>` operator for string pattern matching (not bitstring syntax) | B | — | [✓](https://github.com/lexmag/elixir-style-guide#patterns-matching-binaries) | — | [✓](https://github.com/christopheradams/elixir_style_guide#strings-matching-with-concatenator) |

### Testing

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Assertion order | Put actual value on left, expected value on right (unless pattern match) | T | — | [✓](https://github.com/lexmag/elixir-style-guide#exunit-assertion-side) | — | [✓](https://github.com/christopheradams/elixir_style_guide#testing-assert-order) |

### Metaprogramming

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| Avoid needless metaprogramming | Don't use metaprogramming when not necessary | B | — | — | — | [✓](https://github.com/christopheradams/elixir_style_guide#avoid-metaprogramming) |

### Pitfalls

| Rule | Description | Type | Official Elixir | lexmag | credo | christopheradams |
|------|-------------|------|-----------------|--------|-------|------------------|
| No IEx.pry in production | Never leave `IEx.pry` calls in production code | P | — | — | [✓](https://github.com/rrrene/elixir-style-guide#iex-pry) | — |
| Avoid IO.inspect in production | Be wary of `IO.inspect` in production; use Logger instead | P | — | — | [✓](https://github.com/rrrene/elixir-style-guide#io-inspect) | — |
| No always-true conditionals | Conditionals shouldn't contain expressions always evaluating to same value | P | — | — | [✓](https://github.com/rrrene/elixir-style-guide#debugging-conditionals) | — |
| Avoid Kernel function name conflicts | Be wary of naming variables/functions same as Kernel functions | P | — | — | [✓](https://github.com/rrrene/elixir-style-guide#kernel-functions) | — |
| Avoid stdlib module name conflicts | Be wary of naming modules same as stdlib modules | P | — | — | [✓](https://github.com/rrrene/elixir-style-guide#stdlib-modules) | — |

---

## Summary

### Rules by Guide

- **Official Elixir**: ~15 explicit guidelines (focuses on formatter behavior and design principles)
- **lexmag**: 49 rules (24 linting, 25 formatting)
- **credo**: 43 rules
- **christopheradams**: 76 rules (most comprehensive)

### Consensus Levels

- **All 4 guides**: 1 rule (Newline at EOF)
- **3 guides**: 13 rules (high consensus)
  - Core naming conventions (snake_case, CamelCase, predicates)
  - Essential whitespace rules
  - Never `unless` with `else`
  - Use `__MODULE__`
  - Exception naming
- **2 guides**: 31 rules (medium consensus)
- **1 guide only**: 71 rules (guide-specific recommendations)

### Rules by Type

- **F (Formatting)**: ~45 rules (many automated by official formatter)
- **S (Style)**: ~40 rules (require manual adherence)
- **B (Best Practice)**: ~25 rules
- **P (Pitfall)**: 5 rules (all from Credo)
- **T (Testing)**: 1 rule

### High Consensus Rules

These rules appear in 3 or 4 guides, indicating strong community agreement:

1. Snake case for atoms/functions/variables/attributes
2. CamelCase for modules with uppercase acronyms
3. Predicate functions end with `?`
4. Guard macros use `is_` prefix
5. No trailing whitespace
6. Newline at end of file *(all 4 guides)*
7. Spaces around operators
8. No spaces around matched pairs
9. Never use `unless` with `else`
10. Use `__MODULE__` for self-reference
11. Exception names end with `Error`
12. Use `<>` for string matching
13. Underscores in large numeric literals

---

## Guide Characteristics

### Official Elixir
- **Focus**: How the code formatter works
- **Strength**: Authoritative on what's automated
- **Limitation**: Not a prescriptive style guide
- **Best for**: Understanding formatter behavior and limitations

### lexmag
- **Focus**: Closest to Elixir core team practices
- **Strength**: Clear separation of automated vs manual rules
- **Organization**: Linting vs Formatting
- **Best for**: Following conventions close to Elixir maintainers

### credo
- **Focus**: Static analysis and code quality
- **Strength**: Identifies common pitfalls and refactoring opportunities
- **Organization**: By analysis type (readability, documentation, refactoring, design, pitfalls)
- **Best for**: Automated code review and quality enforcement

### christopheradams
- **Focus**: Comprehensive community consensus
- **Strength**: Most extensive coverage of topics
- **Organization**: By language feature/construct
- **Best for**: Complete reference covering all aspects of Elixir style

---

## Contributing

This comparison is based on the guides as of February 2026. Style guides evolve over time. If you notice discrepancies or updates:

1. Check the source guides for the latest versions
2. Each rule links directly to its source for verification
3. Consider contributing updates to this document or the original guides

## License

This comparison document is provided for informational purposes. Each original style guide has its own license:
- Official Elixir documentation: Apache License 2.0
- lexmag: CC BY 4.0
- credo: CC BY 4.0
- christopheradams: CC BY 3.0

---

*Last updated: February 2026*
