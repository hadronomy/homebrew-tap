# hadronomy/homebrew-tap

```bash
brew tap hadronomy/tap
brew trust hadronomy/tap     # Homebrew 6 gates third-party taps
brew install agent-progress
brew services start agent-progress
```

## agent-progress

Live progress for long-running agent tasks, rendered in the macOS menu bar at
zero context cost. Works with any agent harness, including UI builds where there
is no terminal and no status-line hook.

Built from source on your machine. A locally compiled binary never gets a
`com.apple.quarantine` xattr, so Gatekeeper has nothing to block and the app
needs no Developer ID and no notarization. The cost is the Xcode command line
tools at build time.

Source and the accompanying agent skill: <https://github.com/hadronomy/skills>
