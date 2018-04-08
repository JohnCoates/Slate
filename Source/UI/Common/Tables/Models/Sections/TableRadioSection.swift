//
//  RadioTableSection
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

protocol RadioTableSection: class {
    var selectedIndex: Int { get set }
}

class GenericRadioTableSection<RadioType>: TableSection, RadioTableSection {
    var headerTitle: String?
    var footerTitle: String?
    var typedRows: [GenericRadioRow<RadioType>]
    var rows: [TableRow] {
        return typedRows
    }
    var selectedIndex: Int = 0 {
        didSet {
            updateRowsWithNewSelectedIndex()
            selectedValueChanged?(typedRows[selectedIndex].value)
        }
    }
    var selectedValueChanged: ((RadioType) -> Void)?
    
    init(headerTitle: String? = nil,
         footerTitle: String? = nil, rows: [GenericRadioRow<RadioType>] = []) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.typedRows = rows
    }
    
    func updateRowsWithNewSelectedIndex() {
        for (index, row) in typedRows.enumerated() {
            if selectedIndex == index {
                row.selected = true
            } else {
                row.selected = false
            }
        }
    }
}
