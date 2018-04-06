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
    
    enum CodingKeys: String, CodingKey {
        case size
        case kind
    }
    
    init(resolution: PhotoResolution) {
        kind = resolution.kind
        
        switch resolution {
        case let .custom(width, height):
            size = CGSize(width: width, height: height)
        case .maximum, .notSet:
            break
        }
    }
    
    required init?(coder nsDecoder: NSCoder) {
        let decoder = nsDecoder.keyed(by: CodingKeys.self)
        kind = decoder[.kind]
        
        if decoder.contains(.size) {
            size = decoder[.size]
        }
    }
    
    func encode(with nsEncoder: NSCoder) {
        let encoder = nsEncoder.keyed(by: CodingKeys.self)
        encoder[.kind] = kind
        
        if let size = size {
            encoder[.size] = size
        }
    }
    
    var value: PhotoResolution {
        return PhotoResolution(kind: kind, size: size)
    }
    
    override var description: String {
        return "[DBPhotoResolution \(kind) : \(String(describing: size))]"
    }
    
}
