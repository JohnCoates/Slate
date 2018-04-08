//
//  TableSection
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

protocol TableSection {
    var headerTitle: String? { get }
    var footerTitle: String? { get }
    var rows: [TableRow] { get }
    
    func configuredCell(dequeueFrom table: UITableView,
                        indexPath: IndexPath) -> UITableViewCell
}

class BasicTableSection: TableSection {
    var headerTitle: String?
    var footerTitle: String?
    var rows: [TableRow]
    
    init(headerTitle: String? = nil,
         footerTitle: String? = nil, rows: [TableRow] = []) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.rows = rows
    }
}

extension TableSection {
    func configuredCell(dequeueFrom table: UITableView,
                        indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let row = rows[index]
        return row.configuredCell(dequeueFrom: table, indexPath: indexPath)
    }
}
