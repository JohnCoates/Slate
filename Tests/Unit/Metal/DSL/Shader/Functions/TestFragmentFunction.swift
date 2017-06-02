//
//  TestFragmentFunction.swift
//  Slate
//
//  Created by John Coates on 6/1/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import XCTest
#if os(iOS)
@testable import Slate
#else
@testable import macSlate
#endif

class TestFragmentFunction: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFunctionType() {
        let function = RuntimeShader.testFunction().description
        XCTAssert(function.hasPrefix("fragment float4 \(Constant.functionName)"), "Has correct type")
    }
    
    func testArguments() {
    }
    
    func testVariableDeclarations() {
        let function = RuntimeShader.testFunction().description
        XCTAssert(function.contains("float4 color"), "Has color variable declaration")
    }
    
    func testVariableAssignment() {
        let function = RuntimeShader.testFunction().description
        XCTAssert(function.contains("color = "), "Has color variable declaration")
    }
    
    func testSamplerDeclaration() {
        let function = RuntimeShader.testFunction().description
        let samplerName = Constant.samplerName
        XCTAssert(function.contains("constexpr sampler \(samplerName)"))
    }
    
    func testSamplerFunctionCall() {
        let function = RuntimeShader.testFunction().description
        print("function: \(function)")
        let samplerName = Constant.samplerName
        let textureCoordinates = Constant.vertexOutTextureCoordinates
        XCTAssert(function.contains("\(samplerName).sample(fragmentIn.\(textureCoordinates))"), "Has sampler function call")
    }
}

private class Constant {
    static let functionName = "fragmentPassthrough"
    static let samplerName = RuntimeShader.FragmentFunction.defaultSamplerName
    static let fragmentInName = "fragmentIn"
    static let vertexOutTextureCoordinates = "textureCoordinates"
}

private extension RuntimeShader {
    static func testFunction() -> FragmentFunction {
        var functionMaybe: RuntimeShader.FragmentFunction?
        let _ = buildRuntimeShader(identifier: "fragmentPassthrough") { shader in
            functionMaybe = shader.buildFragmentFunction(name: Constant.functionName,
                                                         returnType: RuntimeShader.Float4.self,
                                                         build: build)
        }
        
        XCTAssertNotNil(functionMaybe, "Function set")
        guard let function = functionMaybe else {
            fatalError("Fragment function couldn't be created")
        }
        
        return function
    }
    
    static func build(function: FragmentFunction) {
        guard let shader = function.shader else {
            fatalError("Missing shader")
        }
//        let VertexInType = shader.VertexInType()
        let VertexOutType = shader.VertexOutType()
    
        let arguments = function.arguments
        let texture: Texture2D = arguments.texture(name: "texture")
        let variables = function.variables
        let color: RuntimeShader.Float4 = variables["color"]
        let sampler = function.defaultSampler
        let fragmentIn = arguments.type(name: Constant.fragmentInName, type: VertexOutType, qualifier: .stageIn)
        let coordinates: Float4 = fragmentIn[Constant.vertexOutTextureCoordinates]
        color == texture.sample(sampler: sampler, coordinates: coordinates)
        function.returnValue = color
    }
}

private func testFunction() -> RuntimeShader.FragmentFunction {
    return RuntimeShader.testFunction()
}
