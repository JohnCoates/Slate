//
//  URL+Paths.swift
//  Slate
//
//  Created by John Coates on 6/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension URL {
    
    static var documentsDirectory: URL {
        let fileManager = FileManager.default
        do {
            return try fileManager.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil, create: true)
        } catch let error {
            fatalError("Failed to locate documents directory: \(error)")
        }
    }
    
    func appendingPathPostfix(_ string: String) -> URL {
        let path = self.path
        return URL(fileURLWithPath: path + string)
    }
    
}
