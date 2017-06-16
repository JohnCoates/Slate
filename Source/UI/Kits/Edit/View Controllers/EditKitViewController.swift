//
//  EditKitViewController.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import UIKit

class EditKitViewController: UITableViewController {
    
    enum Link {
        case link(name: String)
        case iconLink(name: String, icon: ImageAsset)
    }
    
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
        
        setUpTableView()
    }
    
    // MARK: - Configuration
    
    lazy var links: [Link] = {
       return [
        .iconLink(name: "Layout", icon: KitEditImage.layout),
        .iconLink(name: "Photo Settings", icon: KitEditImage.photo),
        .iconLink(name: "Video Settings", icon: KitEditImage.video),
        .iconLink(name: "Preview Settings", icon: KitEditImage.preview)
        ]
    }()
    
    // MARK: - Table View Setup
    
    let headerView = EditKitHeaderView()
    
    func setUpTableView() {
        tableView.backgroundColor = Theme.Kits.background
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear
        
        tableView.registerCell(type: EditKitLinkCell.self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.setAutoLayout(tableHeaderView: headerView)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EditKitLinkCell = tableView.dequeueReusableCell(for: indexPath)
        let link = links[indexPath.item]
        switch link {
        case .link(let name):
            cell.title = name
        case .iconLink(let name, let icon):
            cell.title = name
            cell.icon = icon
        }
        
        return cell
    }
    
}
