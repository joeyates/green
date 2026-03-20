---
title: Build a Changelog
description: Create a Changelog file in the project root following the Keep a Changelog 1.1.0 format, using git history to document changes for each version.
branch: chore/build-changelog
---

## Overview

Create a `Changelog` file in the project root that documents notable changes for each released version (0.1.1 through 0.1.11) following the [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) format. The first release (0.1.1, represented by commit `ee9f0b80`) should simply state "First release". Subsequent versions should categorise their commits using the standard types (Added, Changed, Fixed, Removed). Commits that don't change library behaviour (e.g. bumps, formatting, internal refactors, docs-only) should be skipped. An `[Unreleased]` section should be included at the top.

For each version, the following sources will be considered to determine notable changes:
- Commit messages between version bumps
- Diffs in `test/` between version bumps
- Diffs in `lib/green/rules/` between version bumps

Note: Ignore changes related to `elixir_formatter`.

Versions and their bump dates:
- 0.1.1: 2025-02-12 (first release, commit `ee9f0b80`)
- 0.1.2: 2025-02-12
- 0.1.3: 2025-02-12
- 0.1.4: 2025-02-13
- 0.1.5: 2025-08-05
- 0.1.6: 2025-09-17
- 0.1.7: 2026-01-28
- 0.1.8: 2026-01-29
- 0.1.9: 2026-01-29
- 0.1.10: 2026-02-19
- 0.1.11: 2026-03-20

## Tasks

- [x] Create the `Changelog` file with the header and `[Unreleased]` section
- [x] Add entry for 0.1.11 (1ae2678..65eb2b9)
- [x] Add entry for 0.1.10 (e25757f..1ae2678)
- [x] Add entry for 0.1.9 (4aff85f..e25757f)
- [x] Add entry for 0.1.8 (2928019..4aff85f)
- [x] Add entry for 0.1.7 (55456d1..2928019)
- [x] Add entry for 0.1.6 (88b5b64..55456d1)
- [x] Add entry for 0.1.5 (b90be05..88b5b64)
- [x] Add entry for 0.1.4 (0c59fdc..b90be05)
- [x] Add entry for 0.1.3 (d23ae01..0c59fdc)
- [x] Add entry for 0.1.2 (ee9f0b80..d23ae01)
- [ ] Add entry for 0.1.1 ("First release")
- [ ] Address any additional implementation details that arise during development
- [ ] Mark the plan as "done"

## Principal Files

- `Changelog` — the new file to create
- `mix.exs` — source of `@version` values
- `docs/TODO.md` — TODO item to mark as done

## Acceptance Criteria

- A `Changelog` file exists in the project root
- The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/)
- An `[Unreleased]` section exists at the top
- Version 0.1.1 entry says "First release"
- All versions from 0.1.2 to 0.1.11 have entries with appropriate categorisation
- Commits that don't change library behaviour are not included
- Versions are listed in reverse chronological order (latest first)
- Dates use ISO 8601 format (YYYY-MM-DD)
