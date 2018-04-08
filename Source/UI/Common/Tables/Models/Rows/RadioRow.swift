//
//  RadioRow
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

class RadioRow: TableRow, GenericTableRow {
    typealias CellType = EditKitSettingCell
    var title: String
    var style: TableRowStyle = .radioSelectable
    var selected: Bool = false
    weak var section: RadioTableSection?
    
    init(title: String, selected: Bool = false) {
        self.title = title
        self.selected = selected
    }
    
    func configure(cell: CellType) -> CellType {
        cell.title = title
        cell.showCheckmark = selected
        cell.showDisclosure = false
        return cell
    }
}

class GenericRadioRow<RadioType>: RadioRow {
    var value: RadioType

    init(title: String, selected: Bool = false, value: RadioType) {
        self.value = value
        super.init(title: title, selected: selected)
    }
}
