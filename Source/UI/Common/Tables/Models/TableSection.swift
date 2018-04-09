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
}
