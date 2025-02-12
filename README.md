# Green

![Version](https://img.shields.io/hexpm/v/green)

An Elixir code formatter.

Currently, it can enforce [lexmag's Elixir style guide][lexmag].

[lexmag]: https://github.com/lexmag/elixir-style-guide

## Motivation

The standard Elixir formatter only enforces a small number of rules.
This project aims to enforce enough rules so that the "house style" of a project
can be enforced by the formatter.

## Name

The name "Green" is a reference to bikeshedding, i.e. "All bike sheds should
be green."

## Status

Currently, Green provides `Green.Lexmag.ElixirStyleGuideFormatter` which,
as far as is possible, implements the rules of [lexmag's style guide][lexmag]
that are not already implemented by `mix format`.

## Limitations

Two rules change the order of lines:

* `PreferPipelines` groups `use`, `import`, `assign` and `require` statements,
* `RemoveNilFromStructDefinition` places the list of `nil`-default fields
  at the top of the struct definition.

Where possible, when shifting lines around, Green will try to keep
associated comments with the lines that follow them. However, this is not
always possible. Please check the output of the formatter to ensure that
comments are in the correct place.

### Configuration

This library aims to avoid configuration as far as possible. However, there
will be cases where you will want to tweak behaviour due to the specifics
of your project.

For example, the `PreferPipelines` rule may be applied in some unwanted cases.

ExUnit's `assert` and `refute` are not, by default, in `locals_without_parens` -
the list of functions that can appear without parentheses.
As a result, these calls get converted to pipelines.

To avoid this, add the following to `.formatter.exs`:

```elixir
  locals_without_parens: [assert: 1, refute: 1],
```

This works for locals, but not for function (and macro) calls on modules.

If you want to avoid conversion of these to pipelines, you can add
the following to `.formatter.exs`:

```elixir
  green: [
    prefer_pipelines: [
      ignore_functions: ["My.Module.foo": 1]
    ]
  ]
```

## Roadmap

Implement the other well-known Elixir style guides:

* [Credo's Style Guide](https://github.com/rrrene/elixir-style-guide#readme)
* [Christopher Adams' Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide)

## Lexmag.ElixirStyleGuideFormatter

### Usage

Add the following to your `mix.exs`:

```elixir
defp deps do
  [
    {:green, "~> (See the badge above)"}
  ]
end
```

Modify `.formatter.exs` to include the following:

```elixir
[
  plugins: [Green.Lexmag.ElixirStyleGuideFormatter]
]
```

### Limitations

The implemented rules are marked with a check `✅`.

When it is possible to transform the code to match the style guide, Green will
do so. When automatic transformation is not possible, Green will
leave the code as it is and print a warning. These are marked with an
exclamation mark `❗`.

Rules that are not implemented are marked with a question mark `❔`. This
includes rules where there is no way to objectively judge them, such as
usefulness of comments.

Rules that are implemented by the compiler or `mix format` are marked with
a thumbs up `👍`.

### Linting

✅  Transform nested function calls into pipelines ([L1]),

✅ Transform one-element pipelines into function calls ([L2]),

❔ Don't use anonymous functions in pipelines ([L3]),

✅ Transform `unless...else...` into `if...else...` ([L4]),

✅ Transform `if...else nil` into `if...` ([L5]),

✅ Ensure match-all condition of `cond` has `true` ([L6]),

❔ Use `and` and `or` instead of `&&` and `||` when the arguments are boolean ([L7]),

✅ Use `<>` instead of bitstrings when pattern-matching binaries ([L8]).

[L1]: https://github.com/lexmag/elixir-style-guide#pipeline-operator
[L2]: https://github.com/lexmag/elixir-style-guide#needless-pipeline
[L3]: https://github.com/lexmag/elixir-style-guide#anonymous-pipeline
[L4]: https://github.com/lexmag/elixir-style-guide#no-else-with-unless
[L5]: https://github.com/lexmag/elixir-style-guide#no-nil-else
[L6]: https://github.com/lexmag/elixir-style-guide#true-in-cond
[L7]: https://github.com/lexmag/elixir-style-guide#boolean-operators
[L8]: https://github.com/lexmag/elixir-style-guide#patterns-matching-binaries

### Naming

❗ Enforce snake_case for atoms, functions, variables, attributes ([N1]),

👍 Enforce CamelCase for modules ([N2]),

❔ Enforce predicate functions to end with a question mark ([N3]),

✅ Enforce snake_case for directories and files ([N4]),

❗ Disallow one-letter variable names ([N5]).

[N1]: https://github.com/lexmag/elixir-style-guide#snake-case-atoms-funs-vars-attrs
[N2]: https://github.com/lexmag/elixir-style-guide#camelcase-modules
[N3]: https://github.com/lexmag/elixir-style-guide#predicate-funs-name
[N4]: https://github.com/lexmag/elixir-style-guide#snake-case-dirs-files
[N5]: https://github.com/lexmag/elixir-style-guide#one-letter-var

### Comments

❔ Use only critical comments ([C1]),

❔ Avoid superfluous comments ([C2]).

[C1]: https://github.com/lexmag/elixir-style-guide#critical-comments
[C2]: https://github.com/lexmag/elixir-style-guide#no-superfluous-comments

### Modules

✅ Group and order `use`, `import`, `assign` and `require` statements ([M1]),

✅ Replace the current module name with `__MODULE__` ([M2]).

Notes:

* [M1][M1]:
  This transformation does not take into account comments. Any comment before
  or on the same line as a `use`, `import`, `assign` or `require` statement
  will be left where it is.

[M1]: https://github.com/lexmag/elixir-style-guide#module-layout
[M2]: https://github.com/lexmag/elixir-style-guide#current-module-reference

### Regular Expressions

❔ Prefer pattern matching over regular expressions ([R1]),

❔ Use non-capturing regular expressions ([R2]).

[R1]: https://github.com/lexmag/elixir-style-guide#pattern-matching-over-regexp
[R2]: https://github.com/lexmag/elixir-style-guide#non-capturing-regexp

### Structs

✅ Don't specify `nil` default values for `defstruct` fields ([S1]).

[S1]: https://github.com/lexmag/elixir-style-guide#defstruct-fields-default

### Exceptions

❗ Use `Error` suffix for exception names ([E1]),

❔ Use non-capitalized error messages (except for Mix error messages) without trailing punctuation ([E2]).

[E1]: https://github.com/lexmag/elixir-style-guide#exception-naming
[E2]: https://github.com/lexmag/elixir-style-guide#exception-message

### ExUnit

❔ Put the expression being tested by comparison on the left side ([U1]).

[U1]: https://github.com/lexmag/elixir-style-guide#exunit-assertion-side
