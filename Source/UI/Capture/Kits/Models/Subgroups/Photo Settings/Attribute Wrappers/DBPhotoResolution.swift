//
//  DBPhotoResolution.swift
//  Slate
//
//  Created by John Coates on 8/24/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import CoreGraphics

@objc(DBPhotoResolution)
class DBPhotoResolution: NSObject, NSCoding {
    
    private var size: CGSize?
    private var kind: Int
    
    init(resolution: PhotoSettings.Resolution) {
        kind = resolution.kind
        
        switch resolution {
        case let .custom(width, height):
            size = CGSize(width: width, height: height)
        case .maximum, .notSet:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        kind = aDecoder.decodeInteger(forKey: "kind")
        if aDecoder.containsValue(forKey: "size") {
            size = aDecoder.decodeCGSize(forKey: "size")
        }
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(kind)
        
        if let size = size {
            aCoder.encode(size, forKey: "size")
        }
    }
    
    var value: PhotoSettings.Resolution {
        return PhotoSettings.Resolution(kind: kind, size: size)
    }
    
    override var description: String {
        return "[DBPhotoResolution \(kind) : \(String(describing: size))]"
    }
    
}
