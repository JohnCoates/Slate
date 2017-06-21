//
//  KitListingsViewController.swift
//  Slate
//
//  Created by John Coates on 6/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

private typealias LocalClass = KitListingsViewController

class KitListingsViewController: UITableViewController {

    typealias ObjectType = KitCoreData
    lazy var context = DataManager.context
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Kits"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: .backTapped)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: .addTapped)
        setUpDataSource()
    }

    // MARK: - Table Setup
    
    var dataSource: FetchedResultsDataProvider<KitListingsViewController>!
    var resultsController: NSFetchedResultsController<ObjectType>!
    
    private func setUpDataSource() {
        let request = ObjectType.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        resultsController = NSFetchedResultsController<ObjectType>(fetchRequest: request,
                                                                   managedObjectContext: self.context,
                                                                   sectionNameKeyPath: nil,
                                                                   cacheName: nil)
        dataSource = FetchedResultsDataProvider(tableView: tableView,
                                                fetchedResultsController: resultsController,
                                                delegate: self)
    }

    // MARK: - User Interaction
    
    @objc func addTapped() {
        context.performChanges {
            let component: CaptureComponentCoreData
            component = self.context.insertObject()
            component.frame = DBRect(rect: .zero)
            
            let kit: ObjectType
            kit = self.context.insertObject()
            kit.components = Set()
            kit.components.insert(component)
            kit.name = "Fun Kit"
        }
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let addTapped = #selector(LocalClass.addTapped)
    static let backTapped = #selector(LocalClass.backTapped)
}

// MARK: - Data Source Delegate

extension LocalClass: TableViewDataSourceDelegate {
    
    func configure(_ cell: UITableViewCell, for object: ObjectType) {
        cell.textLabel?.text = "kit: \(object)"
    }
    
}
