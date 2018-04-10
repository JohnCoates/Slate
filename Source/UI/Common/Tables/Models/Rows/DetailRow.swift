//
//  DetailRow
//  Created on 4/10/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

class DetailRow: TableRow, GenericTableRow {
    typealias CellType = EditKitSettingCell
    var title: String
    var detail: String?
    
    init(title: String,
         detail: String? = nil) {
        self.title = title
        self.detail = detail
    }
    
    func configure(cell: CellType) -> CellType {
        cell.title = title
        cell.detail = detail
        cell.showCheckmark = false
        cell.showDisclosure = false
        return cell
    }
}
