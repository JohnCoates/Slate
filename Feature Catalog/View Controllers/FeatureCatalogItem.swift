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
    var section = "Unknown"
    
    var identifier: String {
        return "\(section).\(name)"
    }
    
    var creationBlock: CreationClosure?
    var actionBlock: ActionClosure?
    var hideNavigation = false
    
    init(name: String, hideNavigation: Bool = false,
         creationBlock: @escaping CreationClosure) {
        self.name = name
        self.hideNavigation = hideNavigation
        self.creationBlock = creationBlock
    }
    
    init(name: String,
         actionBlock: @escaping ActionClosure) {
        self.name = name
        self.actionBlock = actionBlock
    }

}
