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
    
    enum CodingKeys: String, CodingKey {
        case rect
    }
    
    init(rect: CGRect) {
        self.rect = rect
    }
    
    required init?(coder nsDecoder: NSCoder) {
        let decoder = nsDecoder.keyed(by: CodingKeys.self)
        rect = decoder[.rect]
    }
    
    func encode(with nsEncoder: NSCoder) {
        let encoder = nsEncoder.keyed(by: CodingKeys.self)
        encoder[.rect] = rect
    }
    
    override var description: String {
        return "[DBRect \(rect)]"
    }
    
}
