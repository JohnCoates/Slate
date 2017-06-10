//
//  String+Extensions.swift
//  Slate
//
//  Created by John Coates on 6/1/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension Array where Element: CustomStringConvertible {
    
    func customJoined(separator: String = ",") -> String {
        return self.map {$0.description}.joined(separator: separator)
    }
    
}
