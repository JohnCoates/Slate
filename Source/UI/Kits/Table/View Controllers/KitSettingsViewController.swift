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
        
        if dataSource.startInEditingMode {
            tableView.setEditing(true, animated: false)
        }
    }
    
    // MARK: - View Events
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    // MARK: - Table View setup
    
    override func setUpTableView() {
        super.setUpTableView()
        
        for type in dataSource.cellTypes {
            tableView.registerCell(type: type)
        }
    }
    
    // MARK: - Table View Data Source
    
    lazy var cachedSections = dataSource.sections
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cachedSections.count
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cachedSections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection sectionIndex: Int) -> String? {
        return cachedSections[sectionIndex].headerTitle
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForFooterInSection sectionIndex: Int) -> String? {
        return cachedSections[sectionIndex].footerTitle
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = cachedSections[indexPath.section]
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
        let section = cachedSections[indexPath.section]
        if let radioSection = section as? RadioTableSection {
            let index = indexPath.row
            if radioSection.selectedIndex != index {
                radioSection.selectedIndex = index
                reloadData()
            }
        }
        
        if let row = section.rows[indexPath.row] as? LinkRow {
            row.didSelect()
        }
    }
    
    func reloadData() {
        cachedSections = dataSource.sections
        tableView.reloadData()
    }
    
    // MARK: - Reordering Table Rows
    
    override func tableView(_ tableView: UITableView,
                            canMoveRowAt indexPath: IndexPath) -> Bool {
        let section = cachedSections[indexPath.section]
        if section is MovableRowsTableSection {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        let section = cachedSections[sourceIndexPath.section]
        if let movableRowsSection = section as? MovableRowsTableSection {
            movableRowsSection.moveRowAt(index: sourceIndexPath.row,
                                         to: destinationIndexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                            toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        // limit to own section
        if sourceIndexPath.section != proposedIndexPath.section {
            return limitProposedMoveToOwnSection(tableView: tableView,
                                                 sourceIndexPath: sourceIndexPath,
                                                 proposedIndexPath: proposedIndexPath)
        }
        return proposedIndexPath
    }
    
    func limitProposedMoveToOwnSection(tableView: UITableView,
                                       sourceIndexPath: IndexPath,
                                       proposedIndexPath: IndexPath) -> IndexPath {
        var row = 0
        if sourceIndexPath.section < proposedIndexPath.section {
            row = tableView.numberOfRows(inSection: sourceIndexPath.section) - 1
        }
        return IndexPath(row: row, section: sourceIndexPath.section)
    }
    
    // MARK: - Editing
    
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView,
                            shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
