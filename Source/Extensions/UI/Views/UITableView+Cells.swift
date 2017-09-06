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
    
    func registerHeader<HeaderType: UITableViewHeaderFooterView>(type: HeaderType.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: String(describing: type))
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
    
    func reusableHeader<HeaderType: UITableViewHeaderFooterView>() -> HeaderType {
        let identifier = String(describing: HeaderType.self)
        guard let untyped = dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            fatalError("No header or footer registered for type \(HeaderType.self)")
        }
        
        guard let cell = untyped as? HeaderType else {
            let error = "Couldn't cast header \(untyped) " +
            "with identifier \(identifier) as \(HeaderType.self)"
            fatalError(error)
        }
        
        return cell
    }

}
