# Elixir Formatter Test Results Summary

---

## Summary

This document summarizes empirical findings from testing the Elixir 1.19.5 formatter against style guide rules.
Tests were designed to validate which formatting conventions are **automatically enforced** by `mix format` versus those left to **developer discretion**.

There are three possible outcomes for each style rule tested:
1. ✅ **Enforced**: The formatter automatically transforms code to comply with the rule.
2. ⚠️ **Error**: The formatter raises an error when code violates the rule, preventing formatting until fixed.
3. ❌ **Not Enforced**: The formatter does not modify code related to the rule, allowing developers to choose their preferred style.

## Results

### Whitespace & Spacing
- ✅ Removes trailing whitespace
- ✅ Ensures newline at end of file  
- ✅ Enforces Unix-style line endings (`\n`)
- ✅ Enforces two-space indentation
- ✅ Enforces spaces around operators and after commas
- ✅ No spaces around matched pairs (brackets, braces, parentheses)
- ✅ Enforces space after comment `#`
- ✅ Enforces space before `->` in 0-arity anonymous functions
- ✅ Enforces spaces around default arguments `\\`
- ✅ No spaces around bitstring segment options
- ✅ No spaces after unary operators and inside range literals
- ⚠️ When there's a space between function name and opening paren, the formatter raises an error
- ❌ The formatter does NOT add parentheses to zero-arity function calls

### Indentation
- ✅ Indents right-hand side of binary operators
- ✅ Enforces single level indentation for multi-line pipelines
- ✅ Indents and aligns successive `with` clauses
- ✅ Enforces specific indentation for `for` special form
- ✅ Avoids expression alignment (doesn't vertically align `=` signs)

### Numeric Literals
- ✅ Adds underscores to large numeric literals (6+ digits)
- ✅ Enforces uppercase letters for hex literals

### Atoms & Strings
- ✅ Enforces double quotes (not single) for quoted atoms
- ✅ Preserves charlist single quote syntax (does NOT convert to ~c sigil)

### Data Structures
- ✅ No trailing comma on last element of multiline collections
- ✅ Omits square brackets from keyword lists when optional

### Control Flow
- ✅ Choice between `:do` keyword and `do`-`end` blocks left to user

### Parentheses
- ✅ Enforces parentheses in `def`/`defp`/`defmacro`/`defmacrop` when function has parameters
- ✅ Enforces parentheses when calling functions with arguments
- ✅ Adds parentheses to functions in pipe chains
- ✅ Never wraps arguments of anonymous functions in parentheses
- ✅ Respects `:locals_without_parens` config for local calls

### Layout
- ✅ Enforces one expression per line (no semicolons)

### Comments
- ✅ Moves trailing comments to previous line
- ✅ Moves comments inside expressions to their own line above

---

## Testing Methodology

Tests were created using an isolated Mix project configured for Elixir 1.19.5. Each test:
1. Provides input code (formatted incorrectly or ambiguously)
2. Runs `mix format` in the test project
3. Compares actual output to expected output
4. Categorizes as enforced (test passes with transformation) or not enforced (test passes with no change)

All 36 tests pass, confirming the empirical findings are accurate.

---

## References

- Test Suite: `test/elixir_formatter_test.exs`
- Test Project: `test/projects/elixir_formatter/`
- Style Guide Comparison: `docs/elixir-style-guide-comparison.md`
- Elixir Version: 1.19.5
