# Green

An Elixir code formatter.

Currently, it can enforce [lexmag's Elixir style guide][lexmag].

[lexmag]: https://github.com/lexmag/elixir-style-guide

# Motivation

The standard Elixir formatter only enforces certain rules. This project aims to
enforce additional styling rules beyond those covered by the standard formatter.

# Name

The name "Green" is a reference to bikeshedding, i.e. "The bike shed is green."

# Status

Green provides `Green.Lexmag.ElixirStyleGuideFormatter` which,
as far as is possible, implements the rules of [lexmag's style guide][lexmag]
that are not already implemented by `mix format`.

# Limitations

Green changes the order of lines in two cases:

* When moving `use`, `import`, `assign` and `require` statements to the top of
  a module,
* When modifying `defstruct` fields which are assigned `nil` as a default value.

Where possible, when shifting lines around, Green will try to keep
associated comments with the lines that follow them. However, this is not
always possible. Please check the output of the formatter to ensure that
comments are in the correct place.

# Roadmap

Implement the other well-known Elixir style guides:

* [Credo's Style Guide](https://github.com/rrrene/elixir-style-guide#readme)
* [Christopher Adams' Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)

# Lexmag.ElixirStyleGuideFormatter

## Usage

Add the following to your `mix.exs`:

```elixir
defp deps do
  [
    {:green, "~> 0.1.0"}
  ]
end
```

Modify `.formatter.exs` to include the following:

```elixir
[
  plugins: [Green.Lexmag.ElixirStyleGuideFormatter]
]
```

## Limitations

Some rules cannot be enforced by a formatter. For example, the rule that
comments should be critical. This is a matter of opinion and cannot be
automatically enforced.

The implemented rules are marked with a check `✓`.

When it is possible to transform the code to match the style guide, Green will
do so. However, it is not always possible to do so. In these cases, Green will
leave the code as it is and print a warning.

## Linting

* [x] Transform nested function calls into pipelines ([L1]),
* [x] Transform one-element pipelines into function calls ([L2]),

❔ Don't use anonymous functions in pipelines ([L3]),

* [x] Transform `unless...else...` into `if...else...` ([L4]),
* [x] Transform `if...else nil` into `if...` ([L5]),
* [x] Ensure match-all condition of `cond` has `true` ([L6]),

❔ Use `and` and `or` instead of `&&` and `||` when the arguments are boolean ([L7]),

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
* [x] Disallow one-letter variable names ([N5]).

[N1]: https://github.com/lexmag/elixir-style-guide#snake-case-atoms-funs-vars-attrs
[N2]: https://github.com/lexmag/elixir-style-guide#camelcase-modules
[N3]: https://github.com/lexmag/elixir-style-guide#predicate-funs-name
[N4]: https://github.com/lexmag/elixir-style-guide#snake-case-dirs-files
[N5]: https://github.com/lexmag/elixir-style-guide#one-letter-var

## Comments

❔ Use only critical comments ([C1]),

❔ Avoid superfluous comments ([C2]).

[C1]: https://github.com/lexmag/elixir-style-guide#critical-comments
[C2]: https://github.com/lexmag/elixir-style-guide#no-superfluous-comments

## Modules

* [x] Group and order `use`, `import`, `assign` and `require` statements ([M1]),
* [x] Replace the current module name with `__MODULE__` ([M2]).

Notes:

* [M1][M1]:
  This transformation does not take into account comments. Any comment before
  or on the same line as a `use`, `import`, `assign` or `require` statement
  will be left where it is.

[M1]: https://github.com/lexmag/elixir-style-guide#module-layout
[M2]: https://github.com/lexmag/elixir-style-guide#current-module-reference

## Regular Expressions

❔ Prefer pattern matching over regular expressions ([R1]),

❔ Use non-capturing regular expressions ([R2]).

[R1]: https://github.com/lexmag/elixir-style-guide#pattern-matching-over-regexp
[R2]: https://github.com/lexmag/elixir-style-guide#non-capturing-regexp

## Structs

* [x] Don't specify `nil` default values for `defstruct` fields ([S1]).

[S1]: https://github.com/lexmag/elixir-style-guide#defstruct-fields-default

## Exceptions

* [x] Use `Error` suffix for exception names ([E1]),

❔ Use non-capitalized error messages (except for Mix error messages) without trailing punctuation ([E2]).

[E1]: https://github.com/lexmag/elixir-style-guide#exception-naming
[E2]: https://github.com/lexmag/elixir-style-guide#exception-message

## ExUnit

❔ Put the expression being tested by comparison on the left side ([U1]).

[U1]: https://github.com/lexmag/elixir-style-guide#exunit-assertion-side
