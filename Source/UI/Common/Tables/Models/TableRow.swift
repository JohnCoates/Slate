//
//  TableRow
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

protocol TableRow {
    var style: TableRowStyle { get }
    var accessory: TableRowAccessory { get }
    
    func configuredCell(dequeueFrom table: UITableView,
                        indexPath: IndexPath) -> UITableViewCell
}

protocol GenericTableRow {
    associatedtype CellType: UITableViewCell
    
    func configure(cell: CellType) -> CellType
}

extension GenericTableRow {
    func configuredCell(dequeueFrom table: UITableView,
                        indexPath: IndexPath) -> UITableViewCell {
        let cell: CellType = table.dequeueReusableCell(for: indexPath)
        return configure(cell: cell)
    }
    
    func configure(cell: CellType) -> CellType {
        return cell
    }
}

enum TableRowStyle {
    case radioSelectable
    case slider
    case textField
}

enum TableRowAccessory {
    case none
    case checkmark
    case disclosureIndicator
}

extension TableRow {
    var accessory: TableRowAccessory {
        return .none
    }
}
