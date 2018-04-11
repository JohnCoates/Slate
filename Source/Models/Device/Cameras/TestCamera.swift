//
//  TestCamera
//  Created on 4/11/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

class TestCamera: Camera {
    
    enum Position {
        case back
        case front
    }
    
    let position: Position
    init(position: Position) {
        self.position = position
    }
    
    var userFacingName: String {
        switch position {
        case .back:
            return "Back Camera"
        case .front:
            return "Front Camera"
        }
    }
    
    var description: String {
        return userFacingName
    }
    
    lazy var maximumResolution: IntSize = {
        switch position {
        case .back:
            return IntSize(width: 4032, height: 3024)
        case .front:
            return IntSize(width: 3088, height: 2320)
        }
    }()
    
    lazy var maximumFrameRate: Int = {
        switch position {
        case .back:
            return 120
        case .front:
            return 60
        }
    }()
    
    var highestResolutionForFrameRateClosure: ((Int) -> IntSize?)?
    
    func highestResolution(forFrameRate targetFrameRate: Int) -> IntSize? {
        let closure = Critical.unwrap(highestResolutionForFrameRateClosure)
        return closure(targetFrameRate)
    }
    
    var highestFrameRateForResolutionClosure: ((IntSize) -> Int?)?
    
    func highestFrameRate(forResolution targetResolution: IntSize) -> Int? {
        let closure = Critical.unwrap(highestFrameRateForResolutionClosure)
        return closure(targetResolution)
    }
    
}
