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
        XCTAssert(function.hasPrefix("fragment float4"), "Has correct type")
    }
    
    func testArguments() {
    }
    
    func testVariableDeclarations() {
        let function = RuntimeShader.testFunction().description
        XCTAssert(function.contains("float4 color"), "Has color variable declaration")
    }
    
    
}

private extension RuntimeShader {
    static func testFunction() -> FragmentFunction {
        var functionMaybe: RuntimeShader.FragmentFunction?
        let _ = buildRuntimeShader(identifier: "fragmentPassthrough") { shader in
            functionMaybe = shader.buildFragmentFunction(name: "fragmentPassthrough", returnType: RuntimeShader.Float4.self) { function in
                let variables = function.variables
                let color: RuntimeShader.Float4 = variables["color"]
                function.returnValue = color
            }
        }
        
        XCTAssertNotNil(functionMaybe, "Function set")
        guard let function = functionMaybe else {
            fatalError("Fragment function couldn't be created")
        }
        
        return function
    }
}

private func testFunction() -> RuntimeShader.FragmentFunction {
    return RuntimeShader.testFunction()
}
