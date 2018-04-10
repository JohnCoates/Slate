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
    var minimum: Float = 1
    var maximum: Float = 100
    var value: Float = 1
    var continuousUpdates = true
    var valueChanged: ((EditKitSliderCell, Float) -> Void)?
    
    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }
    
    func configure(cell: CellType) -> CellType {
        cell.title = title
        cell.detail = detail
        cell.minimum = minimum
        cell.maximum = maximum
        cell.value = value
        cell.continuousUpdates = continuousUpdates
        cell.valueChanged = valueChanged
        return cell
    }
}
