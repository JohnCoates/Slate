//
//  TableDataSource
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

protocol TableDataSource {
    associatedtype BaseType
    associatedtype ValueType
    
    var sections: [TableSection] { get }
}
