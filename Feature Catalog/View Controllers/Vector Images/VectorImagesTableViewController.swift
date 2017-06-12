//
//  VectorImagesTableViewController.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class VectorImagesTableViewController: UITableViewController {

    var sections = [String]()
    var canvases = [[Canvas]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filename = ImageFile.coreAssets.rawValue
        guard let file = Bundle.main.url(forResource: filename, withExtension: "") else {
            fatalError("Couldn't find core assets file!")
        }
        do {
            let reader = try VectorAssetReader(file: file)
            try reader.read()
            sections = reader.sections
            canvases = sections.map { name -> [Canvas] in
                var section = [Canvas]()
                for canvas in reader.canvases where canvas.section == name {
                    section.append(canvas)
                }
                return section
            }
        } catch let error {
            print("Error reading vector assets: \(error)")
        }
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorColor = UIColor.clear
        
        tableView.register(VectorImageTableViewCell.self,
                           forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80

    }
    
    let cellReuseIdentifier = "VectorCell"

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canvases[section].count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let untypedCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier,
                                                        for: indexPath)
        
        if let cell = untypedCell as? VectorImageTableViewCell {
            cell.canvas = canvases[indexPath.section][indexPath.row]
        }
        
        return untypedCell
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
}
