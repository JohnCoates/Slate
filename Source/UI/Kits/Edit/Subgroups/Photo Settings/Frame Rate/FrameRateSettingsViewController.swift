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
    
    lazy var rightBarButton: BarButton? = BarButton(title: "Save", target: self,
                                                    action: #selector(saveTapped))
    
    // MARK: - User Interaction
    
    @objc func saveTapped() {
        kit.photoSettings.frameRate = selectedFrameRate
        kit.save()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Source
    
    var sections: [TableSection] {
        return [frameRateSection, customSection]
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
    
    var customSection: TableSection {
        var rows = [TableRow]()
        let footer = "The higher that you set the frame rate, the more resolution will need to be reduced to keep up. To achieve these higher frame rates make sure you prioritize frame rate over resolution."
        
        rows.append(SliderRow(title: "Frames / sec", detail: "120"))
        return TableSection(headerTitle: "Custom",
                            footerTitle: footer, rows: rows)
    }
    
    var cellTypes: [UITableViewCell.Type] {
        return [
            EditKitSettingCell.self,
            EditKitSliderCell.self
        ]
    }
}
