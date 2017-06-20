//
//  UITableView+Cells.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCell<CellType: UITableViewCell>(type: CellType.Type) {
        register(type, forCellReuseIdentifier: String(describing: type))
    }
    
    func dequeueReusableCell<CellType: UITableViewCell>(for indexPath: IndexPath) -> CellType {
        let identifier = String(describing: CellType.self)
        let untypedCell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        guard let cell = untypedCell as? CellType else {
            let error = "Couldn't cast cell \(untypedCell) " +
            "with identifier \(identifier) as \(CellType.self)"
            fatalError(error)
        }
        
        return cell
    }
    
}
