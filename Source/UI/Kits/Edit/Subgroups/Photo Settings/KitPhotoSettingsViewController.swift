//
//  KitPhotoSettingsViewController.swift
//  Slate
//
//  Created by John Coates on 8/22/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class KitPhotoSettingsViewController: SettingsTableViewController {
    
    private enum Row {
        case resolution
        case frameRate
        case burstSpeed
    }
    
    private lazy var rows: [Row] = {
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
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photo Settings"
    }
    // MARK: - Table View setup
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.registerCell(type: EditKitValueCell.self)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.item]
        
        switch row {
        case .resolution:
            let cell: EditKitValueCell = tableView.dequeueReusableCell(for: indexPath)
            cell.title = "Resolution"
            cell.value = "Maximum"
            cell.constrained = "Constrainted by Frame Rate"
            cell.optimalValue = "3130 x 6400 on this device"
            cell.updateLayout()
            return cell
        case .frameRate:
            let cell: EditKitValueCell = tableView.dequeueReusableCell(for: indexPath)
            cell.title = "Frame Rate"
            cell.value = "Highest"
            cell.optimalValue = "120/sec on this device"
            cell.updateLayout()
            return cell
        case .burstSpeed:
            let cell: EditKitValueCell = tableView.dequeueReusableCell(for: indexPath)
            cell.title = "Burst Speed"
            cell.value = "5/sec"
            cell.updateLayout()
            return cell
        }
    }
    
}
