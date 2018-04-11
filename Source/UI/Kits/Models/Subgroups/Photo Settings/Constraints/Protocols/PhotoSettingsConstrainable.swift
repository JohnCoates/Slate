//
//  PhotoSettingsConstrainable
//  Created on 4/11/18.
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

protocol PhotoSettingsConstrainable {
    associatedtype ValueType: Comparable
    var setting: PhotoSettingsPriority { get }
    func optimalValue(for camera: Camera) -> ValueType
    
    func constrained<Leader: PhotoSettingsConstrainable>(value: ValueType,
                                                         leader: Leader,
                                                         camera: Camera) -> ValueType?
    
    func constrained<LeaderType: PhotoSettingsConstrainable>(value: ValueType,
                                                             leader: LeaderType,
                                                             camera: Camera) -> ConstrainedValue?
}

extension PhotoSettingsConstrainable {
    typealias Constraint = PhotoSettingsConstraint<ValueType>
    typealias Constraint2 = PhotoSettingsConstraint2<ValueType>
    typealias ConstrainedValue = ValueConstraint<ValueType>
}
