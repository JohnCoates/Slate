//
//  ValueConstraint
//  Created on 4/12/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

struct ValueConstraint<Kind: Comparable> {
    let value: Kind
    
    typealias ValueCheck = ((_ oldValue: Kind, _ newValue: Kind) -> Bool)
    private var valueMeetsConstraintClosure: ValueCheck
    
    init(_ value: Kind, evaluateNewValue: ValueCheck? = nil) {
        self.value = value
        if let evaluate = evaluateNewValue {
            valueMeetsConstraintClosure = evaluate
        } else {
            valueMeetsConstraintClosure = { $0 != $1 }
        }
    }
    
    func satisfiesConstraint(_ newValue: Kind) -> Bool {
        return valueMeetsConstraintClosure(value, newValue)
    }
}
