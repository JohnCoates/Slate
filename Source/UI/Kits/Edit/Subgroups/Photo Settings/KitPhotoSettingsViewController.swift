//
//  KitPhotoSettingsViewController.swift
//  Slate
//
//  Created by John Coates on 8/22/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class KitPhotoSettingsViewController: SettingsTableViewController {
    private struct Row {
        var title: String
        var detail: String? = nil
        var disclosure: Bool = false
    }
    
    private enum Setting {
        case resolution
        case frameRate
        case burstSpeed
        
        var rows: [Row] {
            switch self {
            case .resolution:
                return [
                    Row(title: "Selected", detail: "Maximum", disclosure: true),
                    Row(title: "Constrained By", detail: "Frame Rate", disclosure: false),
                    Row(title: "Device Value", detail: "3130 x 6400", disclosure: false)
                ]
            case .frameRate:
                return [
                    Row(title: "Selected", detail: "Highest", disclosure: true),
                    Row(title: "Device Value", detail: "120/sec", disclosure: false)
                ]
            case .burstSpeed:
                return [
                    Row(title: "Selected", detail: "5/sec", disclosure: true),
                    Row(title: "Override Value", detail: "2/sec", disclosure: false)
                ]
            }
        }
        
        var name: String {
            switch self {
            case .resolution:
                return "Resolution"
            case .frameRate:
                return "Frame Rate"
            case .burstSpeed:
                return "Burst Speed"
            }
        }
    }
    
    private lazy var settings: [Setting] = {
        return [
            .resolution,
            .frameRate,
            .burstSpeed
        ]
    }()
    
    // MARK: - Init
    
    let kit: Kit
    
    init(kit: Kit) {
        self.kit = kit
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Settings"
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16,
                                                bottom: 0, right: 0)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16,
                                               bottom: 0, right: 16)
        tableView.separatorColor = Theme.Kits.seperatorColor
    }
    
    // MARK: - Table View setup
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.registerCell(type: EditKitValueCell.self)
        tableView.registerCell(type: EditKitSettingCell.self)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return settings[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let setting = settings[section]
        return setting.name
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.section]
        let row = setting.rows[indexPath.row]
        
        return cell(forRow: row, indexPath: indexPath)
    }
    
    private func cell(forRow row: Row,
                      indexPath: IndexPath) -> UITableViewCell {
        let cell: EditKitSettingCell = tableView.dequeueReusableCell(for: indexPath)
        cell.title = row.title
        cell.detail = row.detail
        cell.showDisclosure = row.disclosure
        return cell
    }
    
}
