//
//  FloatPairFormatter.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AppKit

class FloatPairFormatter: Formatter {
    
    override func string(for obj: Any?) -> String? {
        if obj == nil {
            return nil
        }
        guard let string = obj as? String else {
            fatalError("Invalid object: \(String(describing: obj))")
        }
        
        return string
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                 for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        obj?.pointee = string as NSString
        return true
    }
    
    override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
                                       proposedSelectedRange proposedSelRangePtr: NSRangePointer?,
                                       originalString origString: String,
                                       originalSelectedRange origSelRange: NSRange,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let string = partialStringPtr.pointee
        
        if string.length == 0 {
            return true
        }
        
        let scanner = Scanner(string: string as String)
        
        if !scanner.scanFloat(nil) {
            NSBeep()
            return false
        }
        if !scanner.scanString(",", into: nil) {
            NSBeep()
            return false
        }
        
        if !scanner.scanFloat(nil) {
            NSBeep()
            return false
        }
        
        if !scanner.isAtEnd {
            NSBeep()
            return false
        }
        
        return true
    }
    
}
