//
//  SliderRow
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct SliderRow: TableRow, GenericTableRow {
    typealias CellType = EditKitSliderCell
    var title: String
    var detail: String
    let style: TableRowStyle = .slider
    
    func configure(cell: CellType) -> CellType {
        cell.title = title
        cell.detail = detail
        return cell
    }
}
