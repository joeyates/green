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

## Modules

* [ ] Group and order `use`, `import`, `assign` and `require` statements ([M1]).

Notes:

* [M1][M1]:
  This transformation does not take into account comments. Any comment before
  or on the same line as a `use`, `import`, `assign` or `require` statement
  will be left where it it.

[M1]: https://github.com/lexmag/elixir-style-guide#modules
