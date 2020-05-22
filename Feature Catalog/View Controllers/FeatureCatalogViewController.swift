//
//  FeatureCatalogViewController.swift
//
//  Created by John Coates on 5/5/16.
//

import UIKit

class FeatureCatalogViewController: UITableViewController, UIGestureRecognizerDelegate,
UINavigationControllerDelegate, NavigationConvenience {
    
    // MARK: - Init
    
    init() {
        super.init(style: .grouped)
        title = "Features Catalog"
    }
    
    required init?(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    // MARK: - Setup
    
    let cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMinimalistBackButton()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    var hasAppeared = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.delegate = self
        
        guard !hasAppeared else {
            return
        }
        
        hasAppeared = true

        loadSavedSelection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Navigation Controller Delegate
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        guard let item = shownItem else {
            return
        }
        
        guard self !== viewController else {
            return
        }
        
        if item.hideNavigation {
            navigationController.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        guard self === viewController else {
            // Enable Swipe back
            navigationController.interactivePopGestureRecognizer?.delegate = self
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            return
        }
        
        if navigationController.isNavigationBarHidden {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
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
        cell.selectionStyle = .none
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
        UserDefaults.standard.set(item.identifier, forKey: "feature")
    }
    
    func savedSelection() -> FeatureCatalogItem? {
        guard let feature = UserDefaults.standard.string(forKey: "feature") else {
            return nil
        }
        
        for (sectionIndex, section) in sections.enumerated() {
            for (row, item) in section.items.enumerated() where item.identifier == feature {
                let indexPath = IndexPath(row: row, section: sectionIndex)
                tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                return item
            }
        }
        
        return nil
    }
    
    // MARK: - Execute Item
    
    var shownItem: FeatureCatalogItem?
    
    func execute(item: FeatureCatalogItem) {
        shownItem = item
        
        if let viewController = item.creationBlock?() {
            navigationController?.pushViewController(viewController, animated: true)
        } else if let action = item.actionBlock {
            action()
        }
    }
    
    // MARK: - Items
    
    lazy var sections: [Section] = _sections
    
    struct Section {
        let title: String
        let items: [FeatureCatalogItem]
        
        init(title: String, items: [FeatureCatalogItem]) {
            for item in items {
                item.section = title
            }
            self.title = title
            self.items = items
        }
    }
    
    // MARK: - Navigation Swipe Back
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
