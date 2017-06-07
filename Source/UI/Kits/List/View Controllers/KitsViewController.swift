//
//  KitsViewController.swift
//  Slate
//
//  Created by John Coates on 6/4/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

private typealias LocalClass = KitsViewController
private typealias LocalTheme = Theme.Kits

class KitsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.Kits.background
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorColor = LocalTheme.separatorColor
        
        tableView.register(KitTableViewCell.self,
                           forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        // hide empty table view cells
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table Data Source
    
    let cellReuseIdentifier = "KitCell"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let untypedCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                        for: indexPath)
        
        guard let cell = untypedCell as? KitTableViewCell else {
                fatalError("Table dequed wrong kind of cell: \(untypedCell)")
        }
        
        return cell
    }

}

// MARK: - Theme

extension Theme.Kits {
    static let separatorColor = UIColor(red:0.21, green:0.23, blue:0.29, alpha:1.00)
}
