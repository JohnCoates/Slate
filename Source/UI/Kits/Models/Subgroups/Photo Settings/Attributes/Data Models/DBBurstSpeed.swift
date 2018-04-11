//
//  DBBurstSpeed
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

@objc(DBBurstSpeed)
class DBBurstSpeed: NSObject, NSCoding {
    private var speed: Int?
    private var kind: Int
    
    enum CodingKeys: String, CodingKey {
        case speed
        case kind
    }
    
    init(burstSpeed: BurstSpeed) {
        kind = burstSpeed.kind
        
        switch burstSpeed {
        case let .custom(speed):
            self.speed = speed
        case .maximum, .notSet:
            break
        }
    }
    
    required init?(coder nsDecoder: NSCoder) {
        let decoder = nsDecoder.keyed(by: CodingKeys.self)
        kind = decoder[.kind]
        
        if decoder.contains(.speed) {
            speed = decoder[.speed]
        }
    }
    
    func encode(with nsEncoder: NSCoder) {
        let encoder = nsEncoder.keyed(by: CodingKeys.self)
        encoder[.kind] = kind
        
        if let speed = speed {
            encoder[.speed] = speed
        }
    }
    
    var value: BurstSpeed {
        return BurstSpeed(kind: kind, speed: speed)
    }
    
    override var description: String {
        return "[\(type(of: self)) \(kind) : \(String(describing: speed))]"
    }
}
