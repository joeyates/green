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
that are not already implemented by `mix format`. See [docs/lexmag.md](docs/lexmag.md) for details.

## Usage

Add the following to your `mix.exs`:

```elixir
defp deps do
  [
    {:green, "~> (See the badge above)"}
  ]
end
```

Modify `.formatter.exs` to activate the formatter plugin:

```elixir
[
  plugins: [Green.Lexmag.ElixirStyleGuideFormatter]
]
```

## Limitations

Two rules change the order of lines:

* `PreferPipelines` groups `use`, `import`, `alias` and `require` statements,
* `RemoveNilFromStructDefinition` places the list of `nil`-default fields
  at the top of the struct definition.

Where possible, when shifting lines around, Green will try to keep
associated comments with the lines that follow them. However, this is not
always possible. Please check the output of the formatter to ensure that
comments are in the correct place.

## Configuration

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
