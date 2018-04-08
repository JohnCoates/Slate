//
//  InputRow
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct InputRow: TableRow, GenericTableRow {
    typealias CellType = EditKitInputCell
    
    var title: String
    var style: TableRowStyle = .textField
    var filter: TextFieldFilter = .numeric
    var validate: ((String) -> Bool)?
    var normalize: ((String) -> Bool)?
    var doneEditing: ((String) -> Void)?
}
