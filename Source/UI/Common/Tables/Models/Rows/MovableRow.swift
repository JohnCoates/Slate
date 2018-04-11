//
//  MovableRow
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

class GenericMovableRow<IdentifierType>: TableRow, GenericTableRow {
    typealias CellType = EditKitSettingCell
    
    let title: String
    let identifier: IdentifierType
    
    init(identifier: IdentifierType, title: String) {
        self.identifier = identifier
        self.title = title
    }
    
    func configure(cell: CellType) -> CellType {
        cell.title = title
        cell.showCheckmark = false
        cell.showDisclosure = false
        cell.showsReorderControl = true
        return cell
    }
    
}

extension GenericMovableRow where IdentifierType: RawRepresentable, IdentifierType.RawValue == String {
    convenience init(identifier: IdentifierType) {
        self.init(identifier: identifier, title: identifier.rawValue)
    }
}

extension GenericMovableRow where IdentifierType: CustomStringConvertible {
    convenience init(identifier: IdentifierType) {
        self.init(identifier: identifier, title: identifier.description)
    }
}
