---
title: Validate Tests Against Elixir/Erlang Version Matrix
description: Verify Green's test suite passes across all supported Elixir/Erlang version combinations using asdf, recording results in matrix.json.
branch: chore/validate-version-matrix
---

## Overview

Use `asdf` to install and test Green against every supported Elixir/Erlang version pairing. Elixir versions from 1.16 onwards (latest minor of each major) plus `1.20.0-rc.3` are tested against their compatible OTP releases. Results are compiled into `matrix.json` at the project root (not committed).

## Tasks

- [ ] Determine the full version matrix: query `asdf list all elixir` for latest minor releases of 1.16, 1.17, 1.18, 1.19, and `1.20.0-rc.3`; query `asdf list all erlang` for compatible OTP versions and their latest minors. Write the matrix of version pairs to `matrix.json` with each entry having `elixir`, `erlang`, and a null `result` field
- [ ] For each pairing in `matrix.json`, install the versions via `asdf install`, set them active via `asdf set`, run `mix deps.get`, `mix compile`, and `mix test`, and update the entry's `result` field with pass/fail
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- [mix.exs](mix.exs) — defines `elixir: "~> 1.15"` constraint

## Acceptance Criteria

- Every Elixir version from 1.16 through 1.19 (latest minor), plus `1.20.0-rc.3`, is tested against all compatible Erlang/OTP versions
- `matrix.json` exists at the project root and contains a clear pass/fail result for each Elixir × Erlang combination
- No version-pinning changes or `matrix.json` are committed
