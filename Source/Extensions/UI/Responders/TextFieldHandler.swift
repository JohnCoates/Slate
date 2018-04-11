//
//  TextFieldHandler.swift
//  Slate
//
//  Created by John Coates on 10/23/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

enum TextFieldAllowedInput {
    case numeric
    case alphaNumeric
    case custom(allowed: CharacterSet)
}

protocol TextFieldHandler {
    func inputKind(forTextField textField: UITextField) -> TextFieldAllowedInput
}

// Defaults

extension TextFieldHandler {
    
    func inputKind(forTextField textField: UITextField) -> TextFieldAllowedInput {
        return .alphaNumeric
    }
    
}

extension TextFieldHandler where Self: UITableViewDataSource {
    
    func handleReturn(forTextField textField: TableCellTextField) -> Bool {
        return textField.handleReturn()
    }
    
}
