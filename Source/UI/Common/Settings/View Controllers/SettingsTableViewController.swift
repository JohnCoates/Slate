//
//  SettingsTableViewController.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

enum SettingsLink {
    case link(name: String)
    case iconLink(name: String, icon: ImageAsset)
}

class SettingsTableViewController: UITableViewController, NavigationConvenience {

    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpMinimalistBackButton()
        tableView.indicatorStyle = .white
    }
    
    func setUpTableView() {
        tableView.backgroundColor = Theme.Settings.background
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear
        
        tableView.registerCell(type: EditKitLinkCell.self)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.keyboardDismissMode = .interactive
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        Critical.subclassMustImplementMethod()
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        Critical.subclassMustImplementMethod()
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Critical.subclassMustImplementMethod()
    }
    
}
