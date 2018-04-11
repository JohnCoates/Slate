//
//  DBFrameRate
//  Created on 4/9/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

@objc(DBFrameRate)
class DBFrameRate: NSObject, NSCoding {
    private var rate: Int?
    private var kind: Int
    
    enum CodingKeys: String, CodingKey {
        case rate
        case kind
    }
    
    init(frameRate: FrameRate) {
        kind = frameRate.kind
        
        switch frameRate {
        case let .custom(rate):
            self.rate = rate
        case .maximum, .notSet:
            break
        }
    }
    
    required init?(coder nsDecoder: NSCoder) {
        let decoder = nsDecoder.keyed(by: CodingKeys.self)
        kind = decoder[.kind]
        
        if decoder.contains(.rate) {
            rate = decoder[.rate]
        }
    }
    
    func encode(with nsEncoder: NSCoder) {
        let encoder = nsEncoder.keyed(by: CodingKeys.self)
        encoder[.kind] = kind
        
        if let rate = rate {
            encoder[.rate] = rate
        }
    }
    
    var value: FrameRate {
        return FrameRate(kind: kind, rate: rate)
    }
    
    override var description: String {
        return "[\(type(of: self)) \(kind) : \(String(describing: rate))]"
    }
}
