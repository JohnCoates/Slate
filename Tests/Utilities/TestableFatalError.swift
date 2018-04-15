//
//  TestableFatalError
//  Created on 4/15/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

public func fatalError(_ message: @autoclosure () -> String,
                       file: StaticString = #file, line: UInt = #line) -> Never {
    TestableFatalError.closure(message(), file, line)
}

public struct TestableFatalError {
    fileprivate typealias FatalError = (@autoclosure() -> String, StaticString, UInt) -> Never
    fileprivate static var closure: FatalError = swiftClosure
    private static let swiftClosure = Swift.fatalError
    
    public static func beforeNever(closure: @escaping (String) -> Void) {
        self.closure = { (message: @autoclosure () -> String, _, _) in
            closure(message())
            loopForever()
        }
    }
    
    public static func restore() {
        closure = swiftClosure
    }
    
    private static func loopForever() -> Never {
        while true {
            RunLoop.current.run()
        }
    }
}
