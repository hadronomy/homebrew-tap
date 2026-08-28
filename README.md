# hadronomy/homebrew-tap

```bash
brew install hadronomy/tap/agent-progress
brew services start agent-progress
```

The fully-qualified name grants trust to that one formula. `brew trust
hadronomy/tap` trusts everything here instead, which is more than most people
want.

## Formulae

| Formula | What it is |
|---|---|
| [`agent-progress`](Formula/agent-progress.rb) | Live progress for long-running agent tasks, in the macOS menu bar |

## For contributors

The tap uses Homebrew's own tooling rather than anything bespoke:

| Workflow | Runs | Does |
|---|---|---|
| `tests.yml` | every push and PR | `brew test-bot`: tap syntax, audit, style, and a real build of changed formulae |
| `autobump.yml` | daily at 03:00 UTC | `brew bump`, opening a PR when upstream ships a new version |
| `publish.yml` | manual dispatch | `brew pr-pull`, moving a PR's bottles onto `main` |

Every formula carries a `livecheck` block. Without one, `brew bump` cannot tell
which upstream tags belong to it, and the autobump workflow silently does
nothing.

Check a change locally before opening a PR:

```bash
brew style hadronomy/tap
brew audit --strict --online --formula hadronomy/tap/<name>
brew install --build-from-source hadronomy/tap/<name>
brew test <name>
```

## On signing

Formulae here build from source. A locally compiled binary never gets a
`com.apple.quarantine` xattr, so Gatekeeper has nothing to block and no
Developer ID or notarization is needed. Casks are the opposite: Homebrew
requires signing and notarization for them, and unsigned casks leave the
official tap in September 2026.
