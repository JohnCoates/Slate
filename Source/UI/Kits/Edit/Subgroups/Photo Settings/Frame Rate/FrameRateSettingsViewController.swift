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
    var selectedFrameRate: FrameRate
    lazy var customFrameRate: Float = {
        if case .custom(let frameRate) = selectedFrameRate {
            return Float(frameRate)
        } else {
            return 120
        }
    }()
    
    override init(kit: Kit) {
        selectedFrameRate = kit.photoSettings.frameRate
        super.init(kit: kit)
    }
    
    required init(coder aDecoder: NSCoder) {
        Critical.unimplemented()
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
        var sections: [TableSection] = [frameRateSection]
        if case .custom = selectedFrameRate {
            sections.append(customSection)
        }
        return sections
    }
    
    lazy var frameRateSection: GenericRadioTableSection<FrameRate> = {
        var rows = [GenericRadioRow<FrameRate>]()
        
        rows.append(GenericRadioRow(title: "Default",
                                    value: FrameRate.notSet))
        rows.append(GenericRadioRow(title: "Maximum",
                                    value: FrameRate.maximum))
        rows.append(GenericRadioRow(title: "Custom",
                                    value: FrameRate.custom(rate: Int(customFrameRate))))
        
        let section: GenericRadioTableSection<FrameRate>
        section = GenericRadioTableSection(headerTitle: "Frame Rate",
                                           rows: rows)
        switch selectedFrameRate {
        case .notSet:
            section.selectedIndex = 0
        case .maximum:
            section.selectedIndex = 1
        case .custom:
            section.selectedIndex = 2
        }
        
        section.selectedValueChanged = { [unowned self] value in
            self.selected(value)
        }
        return section
    }()
    
    var customSection: TableSection {
        var rows = [TableRow]()
        let footer = """
                    The higher that you set the frame rate,
                    the more resolution will need to be reduced to keep up.
                    To achieve these higher frame rates make sure you prioritize frame rate over
                    resolution.
                    """.withoutNewLinesAndExtraSpaces
        let value = customFrameRate
        let valueInt = Int(value)
        let valueString = String(valueInt)
        var row = SliderRow(title: "Frames / sec", detail: valueString)
        row.minimum = 1
        row.maximum = 120
        row.value = value
        row.continuousUpdates = true
        row.valueChanged = { [unowned self] (cell, newValue) in
            self.valueChanged(cell: cell, newValue: newValue)
        }
        rows.append(row)
        return BasicTableSection(headerTitle: "Custom",
                                 footerTitle: footer, rows: rows)
    }
    
    // MARK: - Selection changes
    
    func selected(_ newValue: FrameRate) {
        selectedFrameRate = newValue
    }
    
    // MARK: - Slider Value Changes
    
    func valueChanged(cell: EditKitSliderCell, newValue: Float) {
        let value = Int(newValue)
        cell.detail = String(value)
        
        selectedFrameRate = .custom(rate: value)
        customFrameRate = newValue
    }
}
