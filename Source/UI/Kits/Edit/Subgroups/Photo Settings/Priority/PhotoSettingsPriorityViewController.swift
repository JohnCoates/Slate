//
//  PhotoSettingsPriorityViewController
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

class PhotoSettingsPriorityViewController: KitSettingsViewController,
KitSettingsDataSource {
    
    // MARK: - Init
    
    var navigationTitle: String = "Priority Order"
    lazy var rightBarButton: BarButton? = BarButton(title: "Save", target: self,
                                                    action: #selector(saveTapped))
    var startInEditingMode = true
    
    override init(kit: Kit) {
        super.init(kit: kit)
    }
    
    required init(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    // MARK: - Table View setup
    
    override func setUpTableView() {
        super.setUpTableView()
        tableView.setEditing(true, animated: false)
    }
    
    // MARK: - User Interaction
    
    @objc func saveTapped() {
        let priorities = prioritySection.typedRows.map { $0.identifier }
        kit.photoSettings.priorities.items = priorities
        kit.save()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Source
    
    lazy var sections: [TableSection] = [prioritySection]
    
    private typealias Priority = PhotoSettingsPriority
    private lazy var prioritySection: GenericMovableRowsTableSection<Priority> = {
        var rows = [GenericMovableRow<Priority>]()
        
        for item in kit.photoSettings.priorities.items {
            rows.append(GenericMovableRow(identifier: item))
        }
        
        let section: GenericMovableRowsTableSection<Priority>
        section = GenericMovableRowsTableSection(rows: rows)
        return section
    }()
    
    var cellTypes: [UITableViewCell.Type] {
        return [
            EditKitSettingCell.self
        ]
    }
}
