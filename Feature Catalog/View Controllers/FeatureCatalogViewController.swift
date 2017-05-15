//
//  FeatureCatalogViewController.swift
//
//  Created by John Coates on 5/5/16.
//

import UIKit

class FeatureCatalogViewController: UITableViewController {
    
    // MARK: - Init
    
    init() {
        super.init(style: .grouped)
        title = "Features Catalog"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class is not NSCoder compliant")
    }
    
    // MARK: - Setup
    
    let cellIdentifier = "cellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    var hasAppeared = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hasAppeared {
            return
        }
        hasAppeared = true
        loadSavedSelection()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        saveSelection(item: item)
        execute(item: item)
    }
    
    // MARK: - Save/Load Selection
    
    func loadSavedSelection() {
        if let item = savedSelection() {
            execute(item: item)
        }
    }
    
    func saveSelection(item: FeatureCatalogItem) {
        UserDefaults.standard.set(item.name, forKey: "feature")
    }
    
    func savedSelection() -> FeatureCatalogItem? {
        guard let feature = UserDefaults.standard.string(forKey: "feature") else {
            return nil
        }
        
        for section in sections {
            for item in section.items where item.name == feature {
                return item
            }
        }
        
        return nil
    }
    
    // MARK: - Execute Item
    
    func execute(item: FeatureCatalogItem) {
        if let viewController = item.creationBlock?() {
            navigationController?.pushViewController(viewController, animated: true)
        } else if let action = item.actionBlock {
            action()
        }
    }
    
    // MARK: - Items
    
    lazy var sections: [Section] = {
        return [
            self.captureScreen(),
            self.buttons()
        ]
    }()
    
    struct Section {
        let title: String
        let items: [FeatureCatalogItem]
    }
    
    func captureScreen() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Edit Bar",
                               creationBlock: {
                                let vc = SimulatorCaptureViewController()
                                // trigger view load
                                _ = vc.view
                                vc.editBar.isHidden = false
                                return vc })
            ]
        
        return Section(title: "Capture Screen", items: items)
    }
    
    func buttons() -> Section {
        let items: [FeatureCatalogItem] = [
            FeatureCatalogItem(name: "Punch-Through Button",
                               creationBlock: { PunchThroughButtonViewController() })
            
        ]
        
        return Section(title: "Buttons", items: items)
    }
}
