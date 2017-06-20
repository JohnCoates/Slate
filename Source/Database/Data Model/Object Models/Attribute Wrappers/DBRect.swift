//
//  DBRect.swift
//  Slate
//
//  Created by John Coates on 6/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreGraphics

@objc(DBRect)
class DBRect: NSObject, NSCoding {
    
    let rect: CGRect
    
    init(rect: CGRect) {
        self.rect = rect
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.rect = aDecoder.decodeCGRect(forKey: "rect")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rect, forKey: "rect")
    }
    
    override var description: String {
        return "[DBRect \(rect)]"
    }
    
}
