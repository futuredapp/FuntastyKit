//
//  UIViewController+Deselection.swift
//  FuntastyKit
//
//  Created by Zev Eisenberg on 5/13/16, modified by Petr Zvoníček.
//  Copyright © 2016 Raizlabs, The Funtasty. All rights reserved.
//

import UIKit

public protocol Deselectable {
    var indexPathsForSelectedItems: [IndexPath]? { get }
    func selectItem(at indexPath: IndexPath?, animated: Bool)
    func deselectItem(at indexPath: IndexPath, animated: Bool)
}

extension UITableView: Deselectable {
    @nonobjc public var indexPathsForSelectedItems: [IndexPath]? {
        return indexPathsForSelectedRows
    }

    @nonobjc public func selectItem(at indexPath: IndexPath?, animated: Bool) {
        selectRow(at: indexPath, animated: animated, scrollPosition: .none)
    }

    @nonobjc public func deselectItem(at indexPath: IndexPath, animated: Bool) {
        deselectRow(at: indexPath, animated: animated)
    }
}

extension UICollectionView: Deselectable {
    @nonobjc public func selectItem(at indexPath: IndexPath?, animated: Bool) {
        selectItem(at: indexPath, animated: animated, scrollPosition: UICollectionViewScrollPosition())
    }
}

public extension UIViewController {

    ///  Smoothly deselect selected rows in a table view during an animated
    ///  transition, and intelligently reselect those rows if the interactive
    ///  transition is canceled. Call this method from inside your view
    ///  controller's `viewWillAppear(_:)` method.
    ///
    ///  - parameter deselectable: The (de)selectable view in which to perform deselection/reselection.
    @nonobjc func smoothlyDeselectItems(on deselectable: Deselectable?) {
        let selectedIndexPaths = deselectable?.indexPathsForSelectedItems ?? []

        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                for indexPath in selectedIndexPaths {
                    deselectable?.deselectItem(at: indexPath, animated: context.isAnimated)
                }
            }) { context in
                if context.isCancelled {
                    selectedIndexPaths.forEach {
                        deselectable?.selectItem(at: $0, animated: false)
                    }
                }
            }
        } else {
            for indexPath in selectedIndexPaths {
                deselectable?.deselectItem(at: indexPath, animated: false)
            }
        }
    }
}
