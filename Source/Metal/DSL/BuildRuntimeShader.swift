//
//  BuildRuntimeShader.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// /Applications/Xcode.app/Contents//Developer/Platforms/MacOSX.platform/usr/lib/clang/3.5/include/metal/

import Foundation

typealias RuntimeShaderBuild = (RuntimeShader) -> Void
func buildRuntimeShader(identifier: String, build: RuntimeShaderBuild) -> RuntimeShader {
    let shader = RuntimeShader(identifier: identifier)
    build(shader)
    return shader
}
