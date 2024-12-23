#!/usr/bin/env elixir

to_quoted_opts =
  [
    unescape: false,
    literal_encoder: &{:ok, {:__block__, &2, [&1]}},
    token_metadata: true,
    emit_warnings: false
  ]

System.argv()
|> hd()
|> File.read!()
|> Code.string_to_quoted_with_comments!(to_quoted_opts)
|> elem(0)
|> IO.inspect()
