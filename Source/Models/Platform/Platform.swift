//
//  Platform.swift
//  Slate
//
//  Created by John Coates on 9/26/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation

class Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    /// Whether we're targetting a local server or not
    static var isLocal: Bool {
        #if LOCAL
            return true
        #else
            return false
        #endif
    }
    
    /// Whether this is a Release build or not
    static var isProduction: Bool {
        #if DEBUG
            return false
        #else
            return true
        #endif
    }
    
}
