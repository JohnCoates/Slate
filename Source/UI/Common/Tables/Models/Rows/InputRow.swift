//
//  InputRow
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

class InputRowBase: TableRow, GenericTableRow {
    typealias CellType = EditKitInputCell
    
    var title: String
    var value: String?
    var placeholder: String?
    var filter: TextFieldFilter = .noFilter
    var returnKey: UIReturnKeyType = .next
    
    init(title: String, value: String? = nil) {
        self.title = title
        self.value = value
    }
    
    func configuredTypedCell(dequeueFrom table: UITableView,
                             indexPath: IndexPath) -> CellType {
        let cell: CellType = table.dequeueReusableCell(for: indexPath)
        cell.textField.indexPath = indexPath
        cell.textField.tableView = table
        return configure(cell: cell)
    }
    
    func configure(cell: CellType) -> CellType {
        cell.title = title
        cell.value = value
        cell.textField.placeholder = placeholder
        cell.textField.returnKeyType = returnKey
        cell.filter = filter
        configureCallbacks(forCell: cell)
        return cell
    }
    
    func configureCallbacks(forCell cell: CellType) {
        Critical.subclassMustImplementMethod()
    }
    
}

class GenericInputRow<IdentifierType>: InputRowBase {
    let identifier: IdentifierType
    typealias SelfType = GenericInputRow<IdentifierType>
    
//    var validate: ((InputRow, String) -> Bool)?
//    var normalize: ((InputRow, String) -> Bool)?
    var doneEditing: ((SelfType, String) -> Void)?
    var valueChanged: ((SelfType, String) -> Void)?
    
    init(identifier: IdentifierType, title: String, value: String? = nil) {
        self.identifier = identifier
        super.init(title: title, value: value)
    }
    
    override func configureCallbacks(forCell cell: CellType) {
        cell.valueChanged = { [unowned self] (cell, newValue) in
            self.valueChanged?(self, newValue)
        }
        
        cell.doneEditing = { [unowned self] (cell, value) in
            self.doneEditing?(self, value)
        }
    }
    
}
