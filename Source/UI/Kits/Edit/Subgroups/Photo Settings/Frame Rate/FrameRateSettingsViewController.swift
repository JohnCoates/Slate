//
//  FrameRateSettingsViewController
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

class FrameRateSettingsViewController: KitSettingsViewController,
KitSettingsDataSource {
    
    // MARK: - Init
    
    var navigationTitle: String = "Frame Rate"
    
    var selectedFrameRate: PhotoSettings.FrameRate
    
    override init(kit: Kit) {
        selectedFrameRate = kit.photoSettings.frameRate
        super.init(kit: kit)
    }
    
    required init(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("navigation title: \(navigationTitle)")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: .saveTapped)
    }
    
    // MARK: - User Interaction
    
    @objc func saveTapped() {
        kit.photoSettings.frameRate = selectedFrameRate
        kit.save()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Source
    
    var sections: [TableSection] {
        return [frameRateSection]
    }
    
    var frameRateSection: TableSection {
        var rows = [TableRow]()
        rows.append(RadioRow(title: "Default",
                             style: .radioSelectable, selected: true))
        rows.append(RadioRow(title: "Maximum",
                             style: .radioSelectable, selected: false))
        rows.append(RadioRow(title: "Custom",
                             style: .radioSelectable, selected: false))
        
        return TableSection(headerTitle: "Frame Rate",
                            footerTitle: nil, rows: rows);
    }
    
    var cellTypes: [UITableViewCell.Type] {
        return [
            EditKitSettingCell.self
        ]
    }
}

// MARK: - Selector Extension

private typealias LocalClass = FrameRateSettingsViewController

fileprivate extension Selector {
    static let saveTapped = #selector(LocalClass.saveTapped)
}
