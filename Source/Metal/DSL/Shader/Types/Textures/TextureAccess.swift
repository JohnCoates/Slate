//
//  TextureAccess.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

extension RuntimeShader {
    class Texture {
        enum Access: String {
            case sample
            case read
            case write
            case readWrite
        }
    }
}
