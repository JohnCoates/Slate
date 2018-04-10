//
//  SimulatorCamera
//  Created on 4/7/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import Foundation

class SimulatorCamera: Camera {
    
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
    
    func highestResolution(forTargetFrameRate targetFrameRate: Int) -> IntSize? {
        if targetFrameRate >= 120 {
            return IntSize(width: 1280, height: 720)
        } else if targetFrameRate >= 60 {
            return IntSize(width: 1920, height: 1080)
        }
        
        return maximumResolution
    }
}
