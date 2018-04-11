//
//  TableRow
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

protocol TableRow {
    func configuredCell(dequeueFrom table: UITableView,
                        indexPath: IndexPath) -> UITableViewCell
}

protocol GenericTableRow {
    associatedtype CellType: UITableViewCell
    
    func configuredTypedCell(dequeueFrom table: UITableView,
                             indexPath: IndexPath) -> CellType
    
    func configure(cell: CellType) -> CellType
}

extension GenericTableRow {
    
    func configuredCell(dequeueFrom table: UITableView,
                        indexPath: IndexPath) -> UITableViewCell {
        return configuredTypedCell(dequeueFrom: table,
                                   indexPath: indexPath)
    }
    
    func configuredTypedCell(dequeueFrom table: UITableView,
                             indexPath: IndexPath) -> CellType {
        let cell: CellType = table.dequeueReusableCell(for: indexPath)
        return configure(cell: cell)
    }
    
    func configure(cell: CellType) -> CellType {
        return cell
    }
    
}
