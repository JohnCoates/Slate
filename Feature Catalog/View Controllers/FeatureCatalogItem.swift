//
//  FeatureCatalogItem.swift
//
//  Created by John Coates on 5/5/16.
//

import UIKit

class FeatureCatalogItem {
    typealias CreationClosure = (Void) -> UIViewController
    typealias ActionClosure = (Void) -> Void
    
    let name: String
    var creationBlock: CreationClosure?
    var actionBlock: ActionClosure?
    
    init(name: String,
         creationBlock: @escaping CreationClosure) {
        self.name = name
        self.creationBlock = creationBlock
    }
    
    init(name: String,
         actionBlock: @escaping ActionClosure) {
        self.name = name
        self.actionBlock = actionBlock
    }

}
