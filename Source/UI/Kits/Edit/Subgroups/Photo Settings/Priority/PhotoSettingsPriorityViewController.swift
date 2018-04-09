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
//        kit.photoSettings.frameRate = selectedFrameRate
        kit.save()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Source
    
    lazy var sections: [TableSection] = [prioritySection]
    
    private enum Setting: String {
        case resolution = "Resolution"
        case frameRate = "Frame Rate"
        case burstSpeed = "Burst Speed"
        
        var description: String {
            return rawValue
        }
    }
    
    private lazy var prioritySection: GenericMovableRowsTableSection<Setting> = {
        var rows = [GenericMovableRow<Setting>]()
        
        rows.append(GenericMovableRow(identifier: .resolution))
        rows.append(GenericMovableRow(identifier: .frameRate))
        rows.append(GenericMovableRow(identifier: .burstSpeed))
        
        let section: GenericMovableRowsTableSection<Setting>
        section = GenericMovableRowsTableSection(rows: rows)
        return section
    }()
    
    var cellTypes: [UITableViewCell.Type] {
        return [
            EditKitSettingCell.self
        ]
    }
}
