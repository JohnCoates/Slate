//
//  FetchedResultsDataProvider.swift
//  Slate
//
//  Created by John Coates on 6/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol TableViewDataSourceDelegate: class {
    associatedtype Object: NSManagedObject, Managed
    associatedtype Cell: UITableViewCell
    func configure(_ cell: Cell, for object: Object)
}

class FetchedResultsDataProvider<Delegate: TableViewDataSourceDelegate>: NSObject,
NSFetchedResultsControllerDelegate, UITableViewDataSource {
    
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    required init(tableView: UITableView,
                  fetchedResultsController: NSFetchedResultsController<Object>,
                  delegate: Delegate) {
        self.tableView = tableView
        self.fetchedResultsController = fetchedResultsController
        cellIdentifier = String(describing: Cell.self)
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            fatalError("Failed to perform fetch, error: \(error)")
        }
        
        tableView.register(Cell.self,
                           forCellReuseIdentifier: cellIdentifier)
        
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    var selectedObject: Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return nil
        }
        
        return object(at: indexPath)
    }
    
    func object(at indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func reconfigureFetchRequest(withBlock configure: (NSFetchRequest<Object>) -> Void) {
        let cacheName = fetchedResultsController.cacheName
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: cacheName)
        configure(fetchedResultsController.fetchRequest)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            fatalError("Fetch request failed: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: Private
    
    fileprivate let tableView: UITableView
    fileprivate let fetchedResultsController: NSFetchedResultsController<Object>
    fileprivate weak var delegate: Delegate!
    fileprivate let cellIdentifier: String
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? Cell else {
            fatalError("Failed to dequeue cell for \(indexPath)")
        }
        
        delegate.configure(cell, for: object)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("deleting object!")
        let object = self.object(at: indexPath)
        object.managedObjectContext?.performChanges {
            object.managedObjectContext?.delete(object)
        }
    }
    
    // MARK: - FetchedResultsController Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPathMaybe: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let indexPath: IndexPath
        if type == .insert {
            guard let newIndexPath = newIndexPath else {
                fatalError("Missing new indexPath for insertion")
            }
            indexPath = newIndexPath
        } else {
            guard let realIndexPath = indexPathMaybe else {
                fatalError("Missing indexPath")
            }
            indexPath = realIndexPath
        }
        
        switch type {
        case .insert:
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .update:
            let object = self.object(at: indexPath)
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
                break
            }
            delegate.configure(cell, for: object)
        case .move:
            guard let newIndexPath = newIndexPath else {
                fatalError("Missing new indexPath for move")
            }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            assertionFailure("Error: Uncovered case: \(type)")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
