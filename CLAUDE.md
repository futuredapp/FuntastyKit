# CLAUDE.md — FuntastyKit

## Build & Test

This is an iOS framework — use the Xcode toolchain (`xcrun`), not the local Swift toolchain:

```bash
# Build (requires iOS SDK via Xcode)
xcodebuild build -scheme FuntastyKit -destination 'platform=iOS Simulator,name=iPhone 16' -sdk iphonesimulator

# Run tests (matches CI)
xcodebuild test -scheme FuntastyKit -destination 'platform=iOS Simulator,name=iPhone 16' -sdk iphonesimulator

# Lint
swiftlint --strict
```

Note: `swift build` / `swift test` do not work because UIKit is not available on macOS host. Always use `xcodebuild` with an iOS simulator destination.

## Project Structure

Single SPM target:

- **FuntastyKit** (`Sources/FuntastyKit/`) — Core: Coordinator pattern, error handling, UIKit extensions

Tests are in `FuntastyKitTests`.

## Architecture

Swift 6.2 with `defaultIsolation: MainActor.self` on the FuntastyKit target — all code in the module is MainActor-isolated by default. No manual `@MainActor` annotations needed. Use `nonisolated` to opt out where required.

Tests use Swift Testing (`import Testing`, `@Suite`, `@Test`). The test target does **not** have `defaultIsolation` — test suites/types that interact with MainActor-isolated library code need explicit `@MainActor` annotations.

Coordinator protocol hierarchy for UIKit navigation:
`Coordinator` → `DefaultCoordinator` → `ConfiguringCoordinator` → `PushCoordinator` / `ModalCoordinator` / `ShowCoordinator` / `TabBarItemCoordinator`

Each coordinator type provides a default `start()` implementation for its navigation style. `CoordinatorDelegate` notifies on `willStop`/`didStop`.

## SwiftLint

Strict mode enabled. Key style rules to follow:
- `no_extension_access_modifier`: Use `extension Foo { public func ... }`, not `public extension Foo { func ... }`
- `let_var_whitespace`: Blank line before variable declarations
- `pattern_matching_keywords`: Move `let`/`var` outside tuples in pattern matching
- `implicitly_unwrapped_optional`: Avoid `!` optionals
- `multiline_arguments`: Multi-line function calls should have each argument on its own line

Key thresholds:
- Cyclomatic complexity: warning at 10
- Function parameters: max 5
- Large tuple: warning 3, error 4
- Type name/body max length: 50 / 400
- `line_length` is disabled
- `force_cast` and `force_try` are warnings (not errors)

## CI (GitHub Actions)

Runs on PRs (`test.yml`): SwiftLint --strict → xcodebuild test.
