//
//  BurstSpeedSettingsViewController
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

class BurstSpeedSettingsViewController: KitSettingsViewController,
KitSettingsDataSource {
    
    // MARK: - Init
    
    var navigationTitle: String = "Burst Speed"
    var selectedValue: BurstSpeed
    lazy var customValue: Float = {
        if case .custom(let speed) = selectedValue {
            return Float(speed)
        } else {
            return 5
        }
    }()
    
    override init(kit: Kit) {
        selectedValue = kit.photoSettings.burstSpeed
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
        kit.photoSettings.burstSpeed = selectedValue
        kit.save()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Source
    
    var sections: [TableSection] {
        var sections: [TableSection] = [radioSection]
        if case .custom = selectedValue {
            sections.append(customSection)
        }
        return sections
    }
    
    lazy var radioSection: GenericRadioTableSection<BurstSpeed> = {
        var rows = [GenericRadioRow<BurstSpeed>]()
        
        rows.append(GenericRadioRow(title: "Default",
                                    value: BurstSpeed.notSet))
        rows.append(GenericRadioRow(title: "Maximum",
                                    value: BurstSpeed.maximum))
        rows.append(GenericRadioRow(title: "Custom",
                                    value: BurstSpeed.custom(speed: Int(customValue))))
        
        let section: GenericRadioTableSection<BurstSpeed>
        section = GenericRadioTableSection(rows: rows)
        switch selectedValue {
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
                    The higher that you set the Burst Speed,
                    the more Resolution will need to be reduced to keep up.
                    To achieve these higher speeds make sure you prioritize Burst Speed over
                    Resolution.
                    """.withoutNewLinesAndExtraSpaces
        let value = customValue
        let valueInt = Int(value)
        let valueString = String(valueInt)
        var row = SliderRow(title: "Photos / sec", detail: valueString)
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
    
    func selected(_ newValue: BurstSpeed) {
        selectedValue = newValue
    }
    
    // MARK: - Slider Value Changes
    
    func valueChanged(cell: EditKitSliderCell, newValue: Float) {
        let value = Int(newValue)
        cell.detail = String(value)
        
        selectedValue = .custom(speed: value)
        customValue = newValue
    }
}
