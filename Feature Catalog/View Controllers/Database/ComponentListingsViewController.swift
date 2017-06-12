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
    
    var resultsController: NSFetchedResultsController<ObjectType>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Components"
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                                style: .plain,
                                                                target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: .addTapped)
        setUpDataSource()
    }
    
    // MARK: - Table Setup
    
    var dataSource: FetchedResultsDataProvider<ComponentListingsViewController>!
    
    private func setUpDataSource() {
        let request = ObjectType.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        request.fetchBatchSize = 20
        resultsController = NSFetchedResultsController<ObjectType>(fetchRequest: request,
                                                                          managedObjectContext: self.context,
                                                                          sectionNameKeyPath: nil,
                                                                          cacheName: nil)
         dataSource = FetchedResultsDataProvider(tableView: tableView,
                                                 cellIdentifier: cellReuseIdentifier,
                                                 fetchedResultsController: resultsController,
                                                 delegate: self)
    }
    
    // MARK: - View Events
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        addTapped()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return resultsController.fetchedObjects!.count
    }

    let cellReuseIdentifier = "Cell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                 for: indexPath)
        
        let component: ObjectType = resultsController.fetchedObjects![indexPath.item]
        cell.textLabel?.text = "component frame: \(component.frame)"
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("deleting object!")
        let object = dataSource.object(at: indexPath)
        object.managedObjectContext?.performChanges {
            object.managedObjectContext?.delete(object)
        }
    }

    // MARK: - User Interaction
    
    @objc func addTapped() {
        print("entity name: \(ObjectType.entityName)")
        let component = NSEntityDescription.insertNewObject(forEntityName: ObjectType.entityName,
                                                            into: context)
        
        guard let typedComponent = component as? ObjectType else {
            fatalError("Couldn't cast component: \(component)")
        }
        
        typedComponent.frame = DBRect(rect: .zero)
        
        do {
            try context.save()
        } catch let error {
            fatalError("Save failed with error: \(error)")
        }
    }
    
}

// MARK: - Selector Extension

fileprivate extension Selector {
    static let addTapped = #selector(LocalClass.addTapped)
}

// MARK: - Data Source Delegate

extension ComponentListingsViewController: TableViewDataSourceDelegate {
    
    func configure(_ cell: UITableViewCell, for object: ObjectType) {
        cell.textLabel?.text = "component frame: \(object.frame)"
    }
    
}
