//
//  FragmentFunction.swift
//  Slate
//
//  Created by John Coates on 5/31/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

// MARK: - Class

extension RuntimeShader {
    class FragmentFunction {
        let name: String
        weak var shader: RuntimeShader?
        init(name: String, shader: RuntimeShader) {
            self.name = name
            self.shader = shader
        }
        
        lazy var sampler: Sampler = Sampler(name: "constantSampler")
        
        lazy var arguments: ArgumentsManager = ArgumentsManager(function: self)
        
        var textures = [String : Any]()
        
        var returnValue: Any?
    }
}

// MARK: - Extension

extension RuntimeShader {
    typealias FragmentClosure = (FragmentFunction) -> Void
    func buildFragmentFunction(name: String, build: FragmentClosure) {
        let function = FragmentFunction(name: name, shader: self)
        
        build(function)
    }
}
