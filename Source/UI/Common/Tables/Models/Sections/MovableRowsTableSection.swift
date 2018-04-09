//
//  MovableRowsTableSection
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

protocol MovableRowsTableSection: TableSection {
    
}

class GenericMovableRowsTableSection<IdentifierType>: MovableRowsTableSection {

    var headerTitle: String?
    var footerTitle: String?
    var typedRows: [GenericMovableRow<IdentifierType>]
    var rows: [TableRow] {
        return typedRows
    }

    init(headerTitle: String? = nil,
         footerTitle: String? = nil,
         rows: [GenericMovableRow<IdentifierType>] = []) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.typedRows = rows
    }
}
