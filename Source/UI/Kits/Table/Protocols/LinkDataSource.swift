//
//  LinkDataSource
//  Created on 4/10/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

protocol LinkDataSource: class {
    associatedtype TypedLinkRow
    
    func selected(link: TypedLinkRow)
}

extension LinkDataSource {
    var onSelect: ((TypedLinkRow) -> Void) {
        return { [unowned self] link in
            self.selected(link: link)
        }
    }
}
