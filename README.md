# ExCop

An Elixir code formatter.

By default, it enforces [lexmag's Elixir style guide](https://github.com/lexmag/elixir-style-guide)

# Motivation

The standard Elixir formatter only enforces certain rules. This project aims to
enforce additional styling rules beyond those covered by the standard formatter.

# Name

The name is a play on `ex` for Elixir and `cop` from [RuboCop](https://rubocop.org/).

# Roadmap

Ths initial roadmap is to implement the rules of lexmag's style guide that
are not already implemented by `mix format`.

# Rules

## Linting

* [x] Transform nested function calls into pipelines ([L1]),
* [x] Transform one-element pipelines into function calls ([L2]),

❔Don't use anonymous functions in pipelines ([L3]),

* [x] Transform `unless...else...` into `if...else...` ([L4]),
* [x] Transform `if...else nil` into `if...` ([L5]),
* [x] Ensure match-all condition of `cond` has `true` ([L6]),

❔Use `and` and `or` instead of `&&` and `||` when the arguments are boolean ([L7]),

* [x] Use `<>` instead of bitstrings when pattern-matching binaries ([L8]).

[L1]: https://github.com/lexmag/elixir-style-guide#pipeline-operator
[L2]: https://github.com/lexmag/elixir-style-guide#needless-pipeline
[L3]: https://github.com/lexmag/elixir-style-guide#anonymous-pipeline
[L4]: https://github.com/lexmag/elixir-style-guide#no-else-with-unless
[L5]: https://github.com/lexmag/elixir-style-guide#no-nil-else
[L6]: https://github.com/lexmag/elixir-style-guide#true-in-cond
[L7]: https://github.com/lexmag/elixir-style-guide#boolean-operators
[L8]: https://github.com/lexmag/elixir-style-guide#patterns-matching-binaries

## Naming

* [x] Enforce snake_case for atoms, functions, variables, attributes ([N1]),

NO Enforce CamelCase for modules ([N2]),

❔ Enforce predicate functions to end with a question mark ([N3]),

* [x] Enforce snake_case for directories and files ([N4]),
* [ ] Disallow one-letter variable names ([N5]).

[N1]: https://github.com/lexmag/elixir-style-guide#snake-case-atoms-funs-vars-attrs
[N2]: https://github.com/lexmag/elixir-style-guide#camelcase-modules
[N3]: https://github.com/lexmag/elixir-style-guide#predicate-funs-name
[N4]: https://github.com/lexmag/elixir-style-guide#snake-case-dirs-files
[N5]: https://github.com/lexmag/elixir-style-guide#one-letter-var

## Comments

❔Use only critical comments ([C1]),

❔Avoid superfluous comments ([C2]).

[C1]: https://github.com/lexmag/elixir-style-guide#critical-comments
[C2]: https://github.com/lexmag/elixir-style-guide#no-superfluous-comments

## Modules

* [x] Group and order `use`, `import`, `assign` and `require` statements ([M1]),
* [ ] Replace the current module name with `__MODULE__` ([M2]).

Notes:

* [M1][M1]:
  This transformation does not take into account comments. Any comment before
  or on the same line as a `use`, `import`, `assign` or `require` statement
  will be left where it is.

[M1]: https://github.com/lexmag/elixir-style-guide#module-layout
[M2]: https://github.com/lexmag/elixir-style-guide#current-module-reference

## Regular Expressions

* [ ] Prefer pattern matching over regular expressions ([R1]),
* [ ] Use non-capturing regular expressions ([R2]).

[R1]: https://github.com/lexmag/elixir-style-guide#pattern-matching-over-regexp
[R2]: https://github.com/lexmag/elixir-style-guide#non-capturing-regexp

## Structs

* [ ] Don't specify `nil` default values for `defstruct` fields ([S1]).

[S1]: https://github.com/lexmag/elixir-style-guide#defstruct-fields-default

## Exceptions

* [ ] Use `Error` suffix for exception names ([E1]),
* [ ] Use non-capitalized error messages (except for Mix error messages) without trailing punctuation ([E2]).

[E1]: https://github.com/lexmag/elixir-style-guide#exception-naming
[E2]: https://github.com/lexmag/elixir-style-guide#exception-message

## ExUnit

* [ ] Put the expression being tested by comparison on the left side ([U1]).

[U1]: https://github.com/lexmag/elixir-style-guide#exunit-assertion-side
