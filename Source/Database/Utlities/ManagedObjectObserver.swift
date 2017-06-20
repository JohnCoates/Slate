//
//  ManagedObjectObserver.swift
//  Slate
//
//  Created by John Coates on 6/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreData

final class ManagedObjectObserver {
    
    enum ChangeType {
        case delete
        case update
    }
    
    init?(object: NSManagedObject, changeHandler: @escaping (ChangeType) -> Void) {
        guard let context = object.managedObjectContext else {
            return nil
        }
        
        token = context
    }
    
    // MARK: - Private
    private var token: NSObjectProtocol!
    
}
