//
//  LCYCoreDataCollectionView.swift
//  monsoon
//
//  Created by LiChunyu on 15/11/24.
//
//

import CoreData
import UIKit

open class LCYCoreDataCollectionView: UICollectionView, NSFetchedResultsControllerDelegate {
    var entity: String?
    var cacheName: String?

    open var frc: NSFetchedResultsController<NSFetchRequestResult>!

    // MARK: - INITIAL

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - FETCHING

    open func performFetch() throws {
        frc.managedObjectContext.performAndWait { () -> Void in
            do {
                try self.frc.performFetch()
            } catch {
                print("Failed to perform fetch")
            }
            self.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource

    open override var numberOfSections: Int {
        var numberOfSections: Int = 0
        if let sections = self.frc.sections {
            numberOfSections = sections.count
        }
        return numberOfSections
    }

    open override func numberOfItems(inSection section: Int) -> Int {
        var numberOfRow: Int = 0
        if let sections = self.frc.sections {
            numberOfRow = sections[section].numberOfObjects
        }
        return numberOfRow
    }

    // MARK: - DELEGATE: NSFetchedResultsController

    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case NSFetchedResultsChangeType.insert:

            insertSections(IndexSet(integer: sectionIndex))
            break
        case NSFetchedResultsChangeType.delete:
            deleteSections(IndexSet(integer: sectionIndex))
            break
        default:
            break
        }
    }

    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType.insert:
            if let newPath = newIndexPath {
                insertItems(at: [newPath])
            }
            break
        case NSFetchedResultsChangeType.delete:
            if let idxPath = indexPath {
                deleteItems(at: [idxPath])
            }
            break
        case NSFetchedResultsChangeType.update:
            if let newPath = newIndexPath {
                if let idxPath = indexPath {
                    deleteItems(at: [idxPath])
                    insertItems(at: [newPath])
                }
            } else {
                if let idxPath = indexPath {
                    reloadItems(at: [idxPath])
                }
            }
            break
        case NSFetchedResultsChangeType.move:
            if let newPath = newIndexPath {
                if let idxPath = indexPath {
                    deleteItems(at: [idxPath])
                    insertItems(at: [newPath])
                }
            }
            break
        @unknown default:
            break
        }
    }
}
