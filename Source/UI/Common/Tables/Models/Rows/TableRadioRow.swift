//
//  TableRadioRow
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct RadioRow: TableRow, GenericTableRow {
    typealias CellType = EditKitSettingCell
    var title: String
    var style: TableRowStyle = .radioSelectable
    var selected: Bool = false
    
    func configure(cell: CellType) -> CellType {
        cell.title = title
        cell.showCheckmark = selected
        cell.showDisclosure = false
        return cell
    }
}
