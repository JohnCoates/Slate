//
//  KitSettingsViewController
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

class KitSettingsViewController: SettingsTableViewController {
    
    // MARK: - Init
    
    let kit: Kit
    lazy var dataSource: KitSettingsDataSource = {
        guard let source = self as? KitSettingsDataSource else {
            fatalError("Subclass must set dataSource or adopt protocol")
        }
        
        return source
    }()
    
    init(kit: Kit) {
        self.kit = kit
        super.init(style: .grouped)
    }
    
    required init(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = dataSource.navigationTitle
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16,
                                                bottom: 0, right: 0)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16,
                                               bottom: 0, right: 16)
        tableView.separatorColor = Theme.Kits.separatorColor
        
        if let rightBarButton = dataSource.rightBarButton {
            let item = UIBarButtonItem(title: rightBarButton.title,
                                       style: rightBarButton.style,
                                       target: rightBarButton.target,
                                       action: rightBarButton.action)
            navigationItem.rightBarButtonItem = item
        }
    }
    
    // MARK: - View Events
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table View setup
    
    override func setUpTableView() {
        super.setUpTableView()
        
        for type in dataSource.cellTypes {
            tableView.registerCell(type: type)
        }
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sections.count
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return dataSource.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection sectionIndex: Int) -> String? {
        return dataSource.sections[sectionIndex].headerTitle
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForFooterInSection sectionIndex: Int) -> String? {
        return dataSource.sections[sectionIndex].footerTitle
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = dataSource.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row.configuredCell(dequeueFrom: tableView,
                                  indexPath: indexPath)
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView,
            let label = header.textLabel {
            label.textColor = Theme.Kits.headerText
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplayFooterView view: UIView,
                            forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView,
            let label = header.textLabel {
            label.textColor = Theme.Kits.headerText
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let section = dataSource.sections[indexPath.section]
        if let radioSection = section as? RadioTableSection {
            let index = indexPath.row
            if radioSection.selectedIndex != index {
                radioSection.selectedIndex = index
                tableView.reloadData()
            }
        }
    }
    
}

// MARK: - Subclass Protocol

protocol KitSettingsDataSource: class {
    var navigationTitle: String { get }
    
    var cellTypes: [UITableViewCell.Type] { get }
    
    var sections: [TableSection] { get }
    
    var rightBarButton: BarButton? { get }
}

struct BarButton {
    var title: String
    var style: UIBarButtonItemStyle
    weak var target: AnyObject?
    var action: Selector?
    
    init(title: String, style: UIBarButtonItemStyle = .plain,
         target: AnyObject?, action: Selector?) {
        self.title = title
        self.style = style
        self.target = target
        self.action = action
    }
}

extension KitSettingsDataSource {
    var navigationTitle: String {
        return "Implement This"
    }
    
    var cellTypes: [UITableViewCell.Type] {
        return []
    }
    
    var sections: [TableSection] {
        return []
    }
    
    var rightBarButton: BarButton? {
        return nil
    }
}
