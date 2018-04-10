//
//  KitPhotoSettingsViewController.swift
//  Slate
//
//  Created by John Coates on 8/22/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class KitPhotoSettingsViewController: KitSettingsViewController,
KitSettingsDataSource, LinkDataSource {
    
    // MARK: - Data Source
    
    var navigationTitle: String = "Photo Settings"
    
    var sections: [TableSection] {
        return [
            section(.resolution),
            section(.frameRate),
            section(.burstSpeed),
            section(.priorityOrder)
        ]
    }
    
    enum Section: String {
        case resolution = "Resolution"
        case frameRate = "Frame Rate"
        case burstSpeed = "Burst Speed"
        case priorityOrder = ""
    }
    
    private func section(_ section: Section) -> TableSection {
        var rows: [TableRow] = []
        switch section {
        case .resolution:
            rows = resolutionRows()
        case .frameRate:
            rows = frameRateRows()
        case .burstSpeed:
            rows = burstSpeedRows()
        case .priorityOrder:
            rows = priorityOrderdRows()
        }
        
        return BasicTableSection(headerTitle: section.rawValue,
                                 footerTitle: footer(for: section),
                                 rows: rows)
    }
    
    private func footer(for section: Section) -> String? {
        switch section {
        case .burstSpeed:
            return "Value is being overriden by app-wide settings."
        default:
            return nil
        }
    }
    
    typealias TypedLinkRow = GenericLinkRow<Section>
    
    lazy var photoSettings = kit.photoSettings
    
    private func resolutionRows() -> [TableRow] {
        var rows: [TableRow] = []
        rows.append(TypedLinkRow(title: "Selected",
                                 detail: photoSettings.resolution,
                                 identifier: .resolution, onSelect: onSelect))
        if let constrainedBy = photoSettings.resolutionConstrained {
            rows.append(DetailRow(title: "Constrained By", detail: constrainedBy))
        }
        for camera in cameras {
            rows.append(DetailRow(title: camera.userFacingName,
                                  detail: camera.maximumResolution.description))
        }
        return rows
    }
    
    lazy var cameras = CurrentDevice.cameras
    
    private func frameRateRows() -> [TableRow] {
        var rows: [TableRow] = []
        rows.append(TypedLinkRow(title: "Selected", detail: photoSettings.frameRate,
                                 identifier: .frameRate, onSelect: onSelect))
        rows.append(DetailRow(title: "Constrained By", detail: "Frame Rate"))
        rows.append(DetailRow(title: "Back Camera", detail: "120/sec"))
        rows.append(DetailRow(title: "Front Camera", detail: "120/sec"))
        return rows
    }
    
    private func burstSpeedRows() -> [TableRow] {
        var rows: [TableRow] = []
        rows.append(TypedLinkRow(title: "Selected", detail: "5/sec",
                                 identifier: .burstSpeed, onSelect: onSelect))
        rows.append(DetailRow(title: "Override Value", detail: "2/sec"))
        rows.append(DetailRow(title: "Back Camera", detail: "2/sec"))
        rows.append(DetailRow(title: "Front Camera", detail: "2/sec"))
        return rows
    }
 
    private func priorityOrderdRows() -> [TableRow] {
        var rows: [TableRow] = []
        rows.append(TypedLinkRow(title: "Priority Order",
                                 identifier: .priorityOrder, onSelect: onSelect))
        return rows
    }
    
    // MARK: - Selection
    
    func selected(link: TypedLinkRow) {
        let vc = viewController(for: link.identifier)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func viewController(for section: Section) -> UIViewController {
        switch section {
        case .resolution:
            return ResolutionSettingViewController(kit: kit)
        case .frameRate:
            return FrameRateSettingsViewController(kit: kit)
        case .priorityOrder:
            return PhotoSettingsPriorityViewController(kit: kit)
        default:
            Critical.methodNotDefined()
        }
    }
}
