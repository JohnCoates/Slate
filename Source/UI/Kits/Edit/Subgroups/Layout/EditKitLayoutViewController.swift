//
//  EditKitLayoutViewController.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class EditKitLayoutViewController: SettingsTableViewController, LayoutPreviewCellDelegate {

    private enum Row {
        case preview
        case editWithPlaceholder
        case editWithLiveCapture
    }
    
    private lazy var rows: [Row] = {
       return [
        .preview,
        .editWithPlaceholder,
        .editWithLiveCapture
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
        
        title = "Layout"
    }
    
    // MARK: - Table View setup
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.registerCell(type: LayoutPreviewCell.self)
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
        case .preview:
            return layoutCell
        case .editWithPlaceholder:
            let cell: EditKitLinkCell = tableView.dequeueReusableCell(for: indexPath)
            cell.title = "Edit with placeholder"
            return cell
        case .editWithLiveCapture:
            let cell: EditKitLinkCell = tableView.dequeueReusableCell(for: indexPath)
            cell.title = "Edit with live preview"
            return cell
        }
    }
    
    // MARK: - Preview
    
    lazy var layoutCell: LayoutPreviewCell = LayoutPreviewCell(kit: self.kit, delegate: self)
    
    // MARK: - Layout Preview Cell Delegate
    
    func promptUserToSelectPreviewDevice() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let x = UIAlertAction(title: DeviceType.x.rawValue,
                                      style: .default) { action in
                                        self.setPreview(device: .x)
        }
        alertController.addAction(x)
        
        let seven = UIAlertAction(title: DeviceType.seven.rawValue,
                                  style: .default) { action in
            self.setPreview(device: .seven)
        }
        alertController.addAction(seven)
        
        let sevenPlus = UIAlertAction(title: DeviceType.sevenPlus.rawValue,
                                      style: .default) { action in
            self.setPreview(device: .sevenPlus)
        }
        alertController.addAction(sevenPlus)
        
        let se = UIAlertAction(title: DeviceType.se.rawValue,
                               style: .default) { action in
            self.setPreview(device: .se)
        }
        alertController.addAction(se)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setPreview(device: DeviceType) {
        layoutCell.device = device
        tableView.reloadData()
    }
    
}
