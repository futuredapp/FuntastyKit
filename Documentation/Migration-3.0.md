# Migrating from 2.x to 3.0

3.0 requires **Xcode 26 (Swift 6.2)** and **iOS 16**; Swift 5 language mode still works. Only the changes below require action; see the [changelog](../CHANGELOG.md) for the full list.

## CocoaPods support removed

3.0 is distributed via Swift Package Manager only; to stay on CocoaPods, keep `pod 'FuntastyKit', '~> 2.3'`.

After switching, add `import UIKit` where files use UIKit types but only import FuntastyKit.

## Coordinators are `@MainActor`

`Coordinator` and all its sub-protocols, `CoordinatorDelegate` and `Deselectable` are now `@MainActor`. Nothing to do if your target uses default `MainActor` isolation; otherwise annotate code that creates or calls coordinators with `@MainActor`, or reach them with `await` / `Task { @MainActor in … }`.

## `ErrorAction` handlers are `@MainActor @Sendable`

In Swift 6 language mode, create `ErrorAction` closures in `@MainActor` code (view controllers, coordinators), and type closures you pass through as `ErrorAction.ErrorHandler`.

## Removed APIs

| Removed | Replacement |
|---|---|
| `Nibable` | `UINib(nibName: MyView.nibName, bundle: nil).instantiate(withOwner: nil).first as! MyView` |
| `StoryboardType`, `StoryboardReference` | `UIStoryboard(name:bundle:).instantiateViewController(identifier:)` |
| `HairlineLayoutConstraint` | Divide the constant by `traitCollection.displayScale` in code |
| `KeyboardHeightConstraint` | Pin to `view.keyboardLayoutGuide.topAnchor` |
| `FuntastyKitIBInspectable` | Remove the package product; set `layer` properties in code |

> [!WARNING]
> The compiler doesn't catch removals used from Interface Builder. Search your `.xib` and `.storyboard` files for `HairlineLayoutConstraint`, `KeyboardHeightConstraint` and the runtime attributes `borderWidth`, `borderColor` and `shadow…`. Leftover attributes crash when the view loads; leftover constraints silently become plain `NSLayoutConstraint`s.

To keep any of these as they were, copy them from [2.3.0](https://github.com/futuredapp/FuntastyKit/tree/2.3.0/Sources) into your app, add `@MainActor` to copied protocols, and change the *Module* of copied constraint classes in Interface Builder.
