//
//  LinkRow
//  Created on 4/10/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

protocol LinkRow: TableRow {
    func didSelect()
}

class GenericLinkRow<Identifier>: LinkRow, GenericTableRow {
    typealias CellType = EditKitSettingCell
    typealias SelfType = GenericLinkRow<Identifier>
    var title: String
    var detail: String?
    var onSelect: ((SelfType) -> Void)?
    var identifier: Identifier
    
    init(title: String,
         detail: CustomStringConvertible? = nil,
         identifier: Identifier,
         onSelect: ((SelfType) -> Void)? = nil) {
        self.title = title
        self.detail = detail?.description
        self.identifier = identifier
        self.onSelect = onSelect
    }
    
    func didSelect() {
        onSelect?(self)
    }
    
    func configure(cell: CellType) -> CellType {
        cell.title = title
        cell.detail = detail
        cell.showCheckmark = false
        cell.showDisclosure = true
        return cell
    }
}
