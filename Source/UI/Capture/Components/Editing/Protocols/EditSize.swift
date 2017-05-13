//
//  EditSize.swift
//  Slate
//
//  Created by John Coates on 5/12/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

protocol EditSize: class {
    var size: Float { get set }
    var minimumSize: Float { get }
    var maximumSize: Float { get }
}

// MARK: - Defaults

extension EditSize {
    var minimumSize: Float {
        return 20
    }
    
    var maximumSize: Float {
        return 200
    }
}
