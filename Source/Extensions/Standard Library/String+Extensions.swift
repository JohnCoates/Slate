//
//  String+Extensions.swift
//  Slate
//
//  Created by John Coates on 6/1/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension String {
    var withoutNewLinesAndExtraSpaces: String {
        var cleaned = self
        
        cleaned = cleaned.replacingOccurrences(of: "\n", with: " ")
        cleaned = cleaned.replacingOccurrences(of: "\t", with: " ")
        while cleaned.contains("  ") {
            cleaned = cleaned.replacingOccurrences(of: "  ", with: " ")
        }
        return cleaned
    }
}

extension Array where Element: CustomStringConvertible {
    
    func customJoined(separator: String = ",") -> String {
        return self.map {$0.description}.joined(separator: separator)
    }
    
}
