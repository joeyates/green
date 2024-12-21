#!/usr/bin/env elixir

System.argv()
|> hd()
|> File.read!()
|> Code.string_to_quoted!()
|> IO.inspect()
