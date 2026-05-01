# Bootstrap test harness

Layered tests for the chezmoi bootstrap process (the `run_once_*` scripts under
`.chezmoiscripts/`). Two tiers, three jobs.

## Sandbox rule

`chezmoi apply` is destructive and irreversible. The harness must never run it
on a real host machine. Every script that invokes it sources `helpers/guard.sh`,
which refuses to proceed unless **both**:

- `BOOTSTRAP_TEST_SANDBOX=1` is exported, **and**
- a sandbox marker is present (`/.dockerenv`, `$CI=true`, or
  `$BOOTSTRAP_TEST_FORCE=1` as a manual escape hatch).

## Tiers

### Smoke (~10s, host-safe, no Docker required)

```
bash tests/bootstrap/smoke.sh
```

What it checks:

1. `chezmoi execute-template` renders `run_once_before_00_init.sh.tmpl` and
   `.chezmoi.toml.tmpl` against the current OS without template errors.
2. `shellcheck` on the rendered init script. Closes the gap left by the
   pre-commit hooks, which exclude `*.tmpl` because raw Go-template syntax
   breaks shellcheck. (shfmt is intentionally not run on rendered output —
   the source template uses style choices that shfmt would reformat,
   producing noisy diffs on every render. The live shfmt pre-commit hook
   covers regular shell scripts.)
3. `chezmoi apply --dry-run --destination <tmp>`. `--dry-run` does **not**
   execute `run_once_*` scripts, so this only validates that the source
   state can be planned end-to-end.

Coverage caveat: `chezmoi.os` is built-in and not overridable via flags, so
one invocation only validates one OS branch. Local dev (macOS) covers
`darwin`; CI (`ubuntu-latest`) covers `linux`. The Linux branch is also
exercised by `e2e-linux.sh`.

### E2E Linux (~5-10 min, Docker required)

```
bash tests/bootstrap/e2e-linux.sh
```

Builds `Dockerfile` from `ubuntu:26.04` (pinned to `linux/amd64` because the
bootstrap downloads `x86_64` tarballs for `nvim`/`fzf`/`dog`). Runs
`chezmoi apply` inside a non-root `tester` user, then `verify.sh`, then a
second `chezmoi apply` to assert no `run_once_*` re-execution.

On Apple Silicon hosts, the container runs under Rosetta (~5x slower).

### E2E macOS (~30-40 min, GitHub Actions only)

```
bash tests/bootstrap/e2e-macos.sh
```

Refuses to run unless `$CI=true`. On the runner, exports
`HOME=$RUNNER_TEMP/fakehome` to bound the blast radius and applies against
that. Pre-installed Homebrew on `macos-latest` short-circuits the
install step (realistic — most macOS users already have brew).

The `BOOTSTRAP_TEST_FORCE=1` escape hatch exists for manual verification by
the author, with a 5-second pre-flight delay; do not use it lightly.

## CI

`.github/workflows/bootstrap-test.yml` runs all three tiers with path
filters scoped to bootstrap-relevant files (`.chezmoiscripts/**`,
`.chezmoiexternal.toml`, `.chezmoi.toml.tmpl`, `.chezmoiignore`,
`tests/bootstrap/**`, the workflow itself), plus `workflow_dispatch` for
manual runs.

## Skipping the Claude installer

`run_once_after_20_install_claude.sh` honors `CHEZMOI_SKIP_CLAUDE_INSTALL=1`
and exits early. The harness sets it by default — testing third-party
curl-pipe installers adds flakiness without value. Real users leave it unset.

## Layout

```
tests/bootstrap/
  README.md          # this file
  smoke.sh           # tier 1 entrypoint (host-safe)
  e2e-linux.sh       # tier 2 driver: Docker
  e2e-macos.sh       # tier 2 driver: CI-only (or BOOTSTRAP_TEST_FORCE)
  Dockerfile         # ubuntu:26.04, linux/amd64, non-root tester user
  .dockerignore
  verify.sh          # PATH probes + artifact checks (runs inside sandbox)
  helpers/guard.sh   # sandbox enforcement helper
```
