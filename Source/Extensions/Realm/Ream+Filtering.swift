//
//  Ream+Filtering.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    func filter<ParentType: Object>(parentType: ParentType.Type,
                                    subclasses: [ParentType.Type],
                                    predicate: NSPredicate) -> [ParentType] {
        return ([parentType] + subclasses).flatMap { classType in
            return Array(self.objects(classType).filter(predicate))
        }
    }
}
