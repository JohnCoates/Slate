//
//  Critical.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class Critical {
    
    static func cast<CastType>(_ valueMaybe: Any?,
                               errorMessage errorMessageMaybe: String? = nil,
                               file: StaticString = #file,
                               line: UInt = #line,
                               method: StaticString = #function) -> CastType {
        guard let value = valueMaybe else {
            var message: String
            if let errorMessage = errorMessageMaybe {
                message = errorMessage + " : "
            } else {
                message = ""
            }
            message += "Unexpectedly found nil while unwrapping a critical cast " +
                "in \(method) to \(CastType.self)"
            fatalError(message, file: file, line: line)
        }
        
        guard let castValue = value as? CastType else {
            var message: String
            if let errorMessage = errorMessageMaybe {
                message = errorMessage + " : "
            } else {
                message = ""
            }
            message += "Critical cast failed to cast value of type " +
            "\(type(of: value)) to \(CastType.self) in \(method)"
            
            fatalError(message, file: file, line: line)
        }
        
        return castValue
    }
    
    static func methodNotDefined(file: StaticString = #file,
                                 line: UInt = #line,
                                 method: StaticString = #function) -> Never {
        fatalError("Method not defined: \(method)", file: file, line: line)
    }
    
    static func subclassMustImplementMethod(file: StaticString = #file,
                                            line: UInt = #line,
                                            method: StaticString = #function) -> Never {
        fatalError("Method must be implemented by subclass: \(method)", file: file, line: line)
    }
    
}
