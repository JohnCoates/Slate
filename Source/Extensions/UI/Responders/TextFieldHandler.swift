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
        guard let indexPath = textField.indexPath,
            let tableView = textField.tableView else {
            return true
        }
        
        if let nextTextField = nextTextField(for: indexPath, in: tableView) {
            nextTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func nextTextField(for indexPath: IndexPath, in tableView: UITableView) -> UITextField? {
        var currentIndexPath = indexPath
        while let nextIndex = nextIndexPath(for: currentIndexPath, in: tableView) {
            let unattachedCell = self.tableView(tableView, cellForRowAt: nextIndex)
            
            if textField(inViewHierarchy: unattachedCell.contentView) != nil {
                tableView.scrollToRow(at: nextIndex, at: .bottom, animated: false)
                
                if let cell = tableView.cellForRow(at: nextIndex),
                   let nextTextField = textField(inViewHierarchy: cell.contentView) {
                    return nextTextField
                }
            }
            
            currentIndexPath = nextIndex
        }
        
        return nil
    }
    
    private func textField(inViewHierarchy parentView: UIView) -> UITextField? {
        for view in parentView.subviews {
            if let textField = view as? UITextField {
                return textField
            }
            
            if let textField = textField(inViewHierarchy: view) {
                return textField
            }
        }
        
        return nil
    }
    
    
    private func nextIndexPath(for currentIndexPath: IndexPath, in tableView: UITableView) -> IndexPath? {
        let startRow = currentIndexPath.row
        let startSection = currentIndexPath.section
        var firstRow = startRow
        for section in currentIndexPath.section ..< tableView.numberOfSections {
            for row in firstRow ..< tableView.numberOfRows(inSection: section) {
                if row > startRow || section > startSection {
                    return IndexPath(row: row, section: section)
                }
            }
            firstRow = 0
        }
        
        return nil
    }
}
