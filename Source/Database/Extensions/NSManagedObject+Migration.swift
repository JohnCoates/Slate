//
//  NSManagedObject+Migration
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import CoreData

extension NSManagedObject {
    
    func set<Object: DBObject>(object: Object.Type, value: Any, forKey key: Object.CodingKeys) {
        self.setValue(value, forKey: key.rawValue)
    }
    
}
