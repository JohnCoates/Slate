//
//  ResolutionSettingViewController.swift
//  Slate
//
//  Created by John Coates on 10/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class ResolutionSettingViewController: KitSettingsViewController,
KitSettingsDataSource {
    
    // MARK: - Init
    
    var navigationTitle: String = "Resolution"
    var selectedResolution: PhotoResolution
    lazy var customResolution: IntSize = {
        if case let .custom(width, height) = selectedResolution {
            return IntSize(width: width, height: height)
        } else {
            return IntSize(width: 1280, height: 720)
        }
    }()
    
    override init(kit: Kit) {
        selectedResolution = kit.photoSettings.resolution
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
        kit.photoSettings.resolution = selectedResolution
        kit.save()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Source
    
    var sections: [TableSection] {
        var sections: [TableSection] = [frameRateSection]
        if case .custom = selectedResolution {
            sections.append(customSection)
        }
        return sections
    }
    
    lazy var frameRateSection: GenericRadioTableSection<PhotoResolution> = {
        var rows = [GenericRadioRow<PhotoResolution>]()
        
        rows.append(GenericRadioRow(title: "Default",
                                    value: PhotoResolution.notSet))
        rows.append(GenericRadioRow(title: "Maximum",
                                    value: PhotoResolution.maximum))
        rows.append(GenericRadioRow(title: "Custom",
                                    value: PhotoResolution.custom(width: customResolution.width,
                                                                  height: customResolution.height)))
        
        let section: GenericRadioTableSection<PhotoResolution>
        section = GenericRadioTableSection(headerTitle: "Resolution",
                                           rows: rows)
        switch selectedResolution {
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
    
    lazy var customSection: TableSection = {
        var rows = [GenericInputRow<InputKey>]()
        let value = customResolution
        
        rows.append(inputRow(type: .width, value: value.width))
        rows.append(inputRow(type: .height, value: value.height, doneKey: true))
        return BasicTableSection(headerTitle: "Custom", rows: rows)
    }()
    
    private enum InputKey: String {
        case width = "Width"
        case height = "Height"
    }
    
    private func inputRow(type: InputKey, value: Int,
                          doneKey: Bool = false) -> GenericInputRow<InputKey> {
        let row = GenericInputRow<InputKey>(identifier: type,
                                            title: type.rawValue, value: String(value))
        row.filter = .numeric
        if doneKey {
            row.returnKey = .done
        }
        row.valueChanged = { [unowned self] (row, value) in
            self.valueChanged(row: row, value: value)
        }
        return row
    }
    
    // MARK: - Custom Input
    
    private func valueChanged(row: GenericInputRow<InputKey>,
                              value valueString: String) {
        let value = Int(valueString) ?? 0
        
        switch row.identifier {
        case .width:
            customResolution.width = value
        case .height:
            customResolution.height = value
        }
        
        selectedResolution = .custom(width: customResolution.width,
                                     height: customResolution.height)
    }
    
    // MARK: - Selection changes
    
    func selected(_ newValue: PhotoResolution) {
        selectedResolution = newValue
    }
    
}
