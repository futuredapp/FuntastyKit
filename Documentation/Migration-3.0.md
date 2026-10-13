# Migrating from 2.x to 3.0

3.0 requires **Swift 6.2 (Xcode 26)** and **iOS 16**. Only the changes below require action; see the [changelog](../CHANGELOG.md) for the full list.

## CocoaPods support removed

3.0 is distributed via Swift Package Manager only; to stay on CocoaPods, keep `pod 'FuntastyKit', '~> 2.3'`.

After switching, add `import UIKit` where files use UIKit types but only import FuntastyKit — the CocoaPods umbrella header re-exported UIKit, the Swift package does not.

## Coordinators are `@MainActor`

`Coordinator` and all its sub-protocols, `CoordinatorDelegate` and `Deselectable` are now `@MainActor`, and so are your conforming types. Annotate code that creates or calls coordinators with `@MainActor`, or reach them with `await` / `Task { @MainActor in … }`.

## `ErrorAction` handlers are `@MainActor @Sendable`

Closures passed to `ErrorAction(title:style:action:)` must not capture non-`Sendable` state. Capturing a `@MainActor` `self` (view controller, coordinator) is fine.

## Removed APIs

| Removed | Replacement |
|---|---|
| `Nibable` | `UINib(nibName: MyView.nibName, bundle: nil)` (`nibName` is still available) |
| `StoryboardType`, `StoryboardReference` | `UIStoryboard(name:bundle:).instantiateViewController(identifier:)` |
| `HairlineLayoutConstraint` | Constant of `1 / traitCollection.displayScale` |
| `KeyboardHeightConstraint` | `view.keyboardLayoutGuide` |
| `FuntastyKitIBInspectable` | Set `layer` properties in code or via *User Defined Runtime Attributes* |

To keep any of these as they were, copy them from [2.3.0](https://github.com/futuredapp/FuntastyKit/tree/2.3.0/Sources) into your app.
