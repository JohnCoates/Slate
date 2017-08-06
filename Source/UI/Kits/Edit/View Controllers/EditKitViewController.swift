//
//  EditKitViewController.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import UIKit

class EditKitViewController: SettingsTableViewController {
    
    enum SettingsGroup {
        case layout
        case photoSettings
        case videoSettings
        case previewSettings
        
        var link: SettingsLink {
            switch self {
            case .layout:
                return .iconLink(name: "Layout", icon: KitEditImage.layout)
            case .photoSettings:
                return .iconLink(name: "Photo Settings", icon: KitEditImage.photo)
            case .videoSettings:
                return .iconLink(name: "Video Settings", icon: KitEditImage.video)
            case .previewSettings:
                return .iconLink(name: "Preview Settings", icon: KitEditImage.preview)
            }
        }
    }
    
    // MARK: - Init
    
    let kit: Kit
    
    init(kit: Kit) {
        self.kit = kit
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Kit"
    }
    
    // MARK: - Configuration
    
    lazy var settingsGroups: [SettingsGroup] = {
       return [
        .layout,
        .photoSettings,
        .videoSettings,
        .previewSettings
        ]
    }()
    
    // MARK: - Table View Setup
    
    let headerView = EditKitHeaderView()
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.setAutoLayout(tableHeaderView: headerView)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EditKitLinkCell = tableView.dequeueReusableCell(for: indexPath)
        let settingsGroup = settingsGroups[indexPath.item]
        
        switch settingsGroup.link {
        case .link(let name):
            cell.title = name
        case .iconLink(let name, let icon):
            cell.title = name
            cell.icon = icon
        }
        
        return cell
    }
    
    // MARK: - Cell Selection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsGroup = settingsGroups[indexPath.item]
        
        switch settingsGroup {
        case .layout:
            let viewController = EditKitLayoutViewController(kit: kit)
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
}
