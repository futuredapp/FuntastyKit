import UIKit

public protocol Deselectable {
    var indexPathsForSelectedItems: [IndexPath]? { get }
    func selectItem(at indexPath: IndexPath?, animated: Bool)
    func deselectItem(at indexPath: IndexPath, animated: Bool)
}

extension UITableView: Deselectable {
    @nonobjc public var indexPathsForSelectedItems: [IndexPath]? {
        indexPathsForSelectedRows
    }

    @nonobjc
    public func selectItem(at indexPath: IndexPath?, animated: Bool) {
        selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }

    @nonobjc
    public func deselectItem(at indexPath: IndexPath, animated: Bool) {
        deselectRow(at: indexPath, animated: animated)
    }
}

extension UICollectionView: Deselectable {
    @nonobjc
    public func selectItem(at indexPath: IndexPath?, animated: Bool) {
        selectItem(at: indexPath, animated: animated, scrollPosition: UICollectionView.ScrollPosition())
    }
}

public extension UIViewController {

    ///  Smoothly deselect selected rows in a table view during an animated
    ///  transition, and intelligently reselect those rows if the interactive
    ///  transition is canceled. Call this method from inside your view
    ///  controller's `viewWillAppear(_:)` method.
    ///
    ///  - parameter deselectable: The (de)selectable view in which to perform deselection/reselection.
    @nonobjc
    func smoothlyDeselectItems(on deselectable: Deselectable?) {
        let selectedIndexPaths = deselectable?.indexPathsForSelectedItems ?? []

        if let coordinator = transitionCoordinator {
            let success = coordinator.animate(alongsideTransition: { [weak self] context in
                self?.switchSelectedItemsState(
                    on: deselectable,
                    selectedIndexPaths: selectedIndexPaths,
                    shouldBeSelected: false,
                    animated: context.isAnimated
                )
            }, completion: { [weak self] context in
                if context.isCancelled {
                    self?.switchSelectedItemsState(
                        on: deselectable,
                        selectedIndexPaths: selectedIndexPaths,
                        shouldBeSelected: true,
                        animated: false
                    )
                }
            })
            if !success {
                switchSelectedItemsState(
                    on: deselectable,
                    selectedIndexPaths: selectedIndexPaths,
                    shouldBeSelected: false,
                    animated: false
                )
            }
        } else {
            switchSelectedItemsState(
                on: deselectable,
                selectedIndexPaths: selectedIndexPaths,
                shouldBeSelected: false,
                animated: false
            )
        }
    }

    private func switchSelectedItemsState(
        on deselectable: Deselectable?,
        selectedIndexPaths: [IndexPath],
        shouldBeSelected: Bool,
        animated: Bool
    ) {
        guard let deselectable = deselectable else {
            return
        }
        selectedIndexPaths.forEach {
            let switchSelectionFunc = shouldBeSelected ? deselectable.selectItem : deselectable.deselectItem
            switchSelectionFunc($0, animated)
        }
    }
}
