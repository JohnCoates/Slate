//
//  KitPhotoSettingsViewController.swift
//  Slate
//
//  Created by John Coates on 8/22/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class KitPhotoSettingsViewController: SettingsTableViewController {
    
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
        tableView.separatorColor = Theme.Kits.separatorColor
    }
    
    // MARK: - View Events
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        return settings[section].rows(forKit: kit).count
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        let setting = settings[section]
        return setting.name
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForFooterInSection section: Int) -> String? {
        let setting = settings[section]
        return setting.footer
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.section]
        let row = setting.rows(forKit: kit)[indexPath.row]
        
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
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView,
            let label = header.textLabel {
            label.textColor = Theme.Kits.headerText
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView,
            let label = header.textLabel {
            label.textColor = Theme.Kits.headerText
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.section]
        let row = setting.rows(forKit: kit)[indexPath.row]
        
        guard let editableSetting = row.editableSetting else {
            return
        }
        
        let viewController = editableSetting.editViewController(forKit: kit)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Value Types

fileprivate extension KitPhotoSettingsViewController {
    
    fileprivate struct Row {
        var title: String
        var detail: String?
        var disclosure = false
        var editableSetting: Setting?
        
        init(title: String, detail: String,
             disclosure: Bool, editableSetting: Setting? = nil) {
            self.title = title
            self.detail = detail
            self.disclosure = disclosure
            self.editableSetting = editableSetting
        }
    }
    
    enum Setting {
        case resolution
        case frameRate
        case burstSpeed
        
        func rows(forKit kit: Kit) -> [Row] {
            let selected: String
            
            switch self {
            case .resolution:
                 selected = kit.photoSettings.resolution.userFacingDescription
                 let cameras = CurrentDevice.cameras
                 
                 var rows: [Row] = [
                    Row(title: "Selected", detail: selected, disclosure: true, editableSetting: self),
                    Row(title: "Constrained By", detail: "Frame Rate", disclosure: false)
                 ]
                
                 for camera in cameras {
                    let maximumResolution = camera.maximumResolution
                    let detail = "\(maximumResolution.width) x \(maximumResolution.height)"
                    rows.append(Row(title: camera.userFacingName, detail: detail, disclosure: false))
                }
                
                return rows
                
            case .frameRate:
                return [
                    Row(title: "Selected", detail: "Highest", disclosure: true, editableSetting: self),
                    Row(title: "Device Value", detail: "120/sec", disclosure: false)
                ]
            case .burstSpeed:
                return [
                    Row(title: "Selected", detail: "5/sec", disclosure: true, editableSetting: self),
                    Row(title: "Override Value", detail: "2/sec", disclosure: false)
                ]
            }
        }
        
        func editViewController(forKit kit: Kit) -> UIViewController {
            switch self {
            case .resolution:
                return ResolutionSettingViewController(kit: kit)
            default:
                fatalError("Edit view controller for \(self) has not been implemented")
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
        
        var footer: String? {
            switch self {
            case .burstSpeed:
                return "Value is being overriden by app-wide settings."
            default:
                return nil
            }
        }
    }
}
