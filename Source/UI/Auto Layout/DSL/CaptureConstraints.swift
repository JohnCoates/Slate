//
//  CaptureConstraints
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

// MARK: - Capturing

/// Used only by Auto Layout DSL
internal var storedConstraints: [NSLayoutConstraint]?

/// Returns all constraints constructed in closure, uses a global, not thread-safe.
/// Run on main thread only!
func captureConstraints(constructedInClosure closure: () -> Void) -> [NSLayoutConstraint] {
    assert(Thread.isMainThread)
    
    storedConstraints = [NSLayoutConstraint]()
    closure()
    
    guard let stored = storedConstraints else {
        assertionFailure("storedConstraints unexpectedly nil")
        return []
    }
    
    storedConstraints = nil
    return stored
}
