# Changelog

All notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-03-17

See the [migration guide](Documentation/Migration-3.0.md) for upgrade steps.

### Breaking

- Requires Swift 6.2 (Xcode 26) and iOS 16.
- CocoaPods support removed; the package is distributed via Swift Package Manager only.
- `Coordinator`, `DefaultCoordinator`, `ConfiguringCoordinator`, `PushCoordinator`, `ModalCoordinator`, `ShowCoordinator`, `TabBarItemCoordinator`, `CoordinatorDelegate`, `Deselectable`, `AlertCoordinator` and `ErrorAction.alertStyle()` / `alertAction()` are `@MainActor`.
- `ErrorAction.ErrorHandler` is `@MainActor @Sendable () -> Void`.

### Added

- `Sendable` conformance for `ErrorAction`, `ErrorAction.Style`, `AlertCoordinator.Style` and `AlertCoordinator.Source`.
- `ErrorAction.title`, `action` and `style` are public.

### Changed

- Public signatures use explicit existentials (`any CoordinatorDelegate`, `any Error`, `any Deselectable`).

### Removed

- `Nibable` protocol. `UIView.nibName` remains available.
- `StoryboardType` and `StoryboardReference`.
- `HairlineLayoutConstraint` and `KeyboardHeightConstraint`.
- `FuntastyKitIBInspectable` library and its `UIView` IBInspectable extensions.

## Earlier versions

See [GitHub Releases](https://github.com/futuredapp/FuntastyKit/releases) for 2.3.0 and older.

[3.0.0]: https://github.com/futuredapp/FuntastyKit/compare/2.3.0...3.0.0
