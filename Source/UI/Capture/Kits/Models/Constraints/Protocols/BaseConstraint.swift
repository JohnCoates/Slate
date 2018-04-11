//
//  BaseConstraint
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

protocol BaseConstraint {
    associatedtype Kind: CustomStringConvertible
    var by: Kind { get }
}

extension Array where Element: BaseConstraint {
    var constrainers: String {
        return self.map { $0.by.description }.unique.joined(separator: ", ")
    }
}
