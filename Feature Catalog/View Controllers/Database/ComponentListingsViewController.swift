//
//  ComponentListingsViewController.swift
//  Slate
//
//  Created by John Coates on 6/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import CoreData

private typealias LocalClass = ComponentListingsViewController

class ComponentListingsViewController: UITableViewController {

    typealias ObjectType = CaptureComponentCoreData
    lazy var context = DataManager.context
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Components"
        
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
    
    var dataSource: FetchedResultsDataProvider<ComponentListingsViewController>!
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
    
    // MARK: - View Events
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        addTapped()
    }

    let cellReuseIdentifier = "Cell"

    // MARK: - User Interaction
    
    @objc func addTapped() {
        context.performChanges {
            let component: ObjectType
            component = self.context.insertObject()
            component.frame = DBRect(rect: .zero)
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

extension ComponentListingsViewController: TableViewDataSourceDelegate {
    
    func configure(_ cell: UITableViewCell, for object: ObjectType) {
        cell.textLabel?.text = "component frame: \(object.frame)"
    }
    
}
