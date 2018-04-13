//
//  AutoLayoutDSLTests
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import XCTest
#if os(iOS)
    @testable import Slate
#else
    @testable import macSlate
#endif

class AutoLayoutDSLTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOperators() {
        let parentView = UIView()
        let childView = UIView()
        parentView.addSubview(childView)
        let views = [parentView, childView]
        
        buildSingle(attribute: .left, views: views) { $0.left --> $1 }
        buildSingle(attribute: .right, views: views) { $0.right --> $1 }
        buildSingle(attribute: .top, views: views) { $0.top --> $1 }
        buildSingle(attribute: .bottom, views: views) { $0.bottom --> $1 }
        buildSingle(attribute: .width, views: views) { $0.width --> $1 }
        buildSingle(attribute: .height, views: views) { $0.height --> $1 }
        buildSingle(attribute: .centerX, views: views) { $0.centerX --> $1 }
        buildSingle(attribute: .centerY, views: views) { $0.centerY --> $1 }
        buildSingle(attribute: .leading, views: views) { $0.leading --> $1 }
        buildSingle(attribute: .trailing, views: views) { $0.trailing --> $1 }
        
        #if os(iOS)
        buildSingle(attribute: .leftMargin, views: views) { $0.leftMargin --> $1 }
        buildSingle(attribute: .rightMargin, views: views) { $0.rightMargin --> $1 }
        buildSingle(attribute: .topMargin, views: views) { $0.topMargin --> $1 }
        buildSingle(attribute: .bottomMargin, views: views) { $0.bottomMargin --> $1 }
        buildSingle(attribute: .leadingMargin, views: views) { $0.leadingMargin --> $1 }
        buildSingle(attribute: .trailingMargin, views: views) { $0.trailingMargin --> $1 }
        buildSingle(attribute: .centerXWithinMargins, views: views) { $0.centerXWithinMargins --> $1 }
        buildSingle(attribute: .centerYWithinMargins, views: views) { $0.centerYWithinMargins --> $1 }
        buildMultiple(attributes: [.centerXWithinMargins, .centerYWithinMargins],
                      views: views) { $0.centerXYWithinMargins --> $1 }
        #endif
        
        buildMultiple(attributes: [.width, .height], views: views) { $0.size --> $1 }
        buildMultiple(attributes: [.left, .top, .right, .bottom], views: views) { $0.edges --> $1 }
    }
    
    func buildSingle(attribute: NSLayoutAttribute,
                     views: [UIView],
                     file: StaticString = #file, line: UInt = #line,
                     generate: (UIView, UIView) -> Void) {
        let constraints = captureConstraints(constructedInClosure: {
            generate(views[0], views[1])
        })
        XCTAssertEqual(constraints.count, 1, file: file, line: line)
        let generated = constraints[0]
        XCTAssertEqual(generated.firstAttribute, attribute, file: file, line: line)
        XCTAssertEqual(generated.secondAttribute, attribute, file: file, line: line)
        XCTAssertTrue(generated.firstItem === views[0], file: file, line: line)
        XCTAssertTrue(generated.secondItem === views[1], file: file, line: line)
        NSLayoutConstraint.deactivate(constraints)
    }
    
    func buildMultiple(attributes: [NSLayoutAttribute],
                       views: [UIView],
                       file: StaticString = #file, line: UInt = #line,
                       generate: (UIView, UIView) -> Void) {
        let constraints = captureConstraints(constructedInClosure: {
            generate(views[0], views[1])
        })
        XCTAssertNotEqual(constraints.count, 1, file: file, line: line)
        for (index, generated) in constraints.enumerated() {
            XCTAssertEqual(generated.firstAttribute, attributes[index], file: file, line: line)
            XCTAssertEqual(generated.secondAttribute, attributes[index], file: file, line: line)
            XCTAssertTrue(generated.firstItem === views[0], file: file, line: line)
            XCTAssertTrue(generated.secondItem === views[1], file: file, line: line)
        }
        
        NSLayoutConstraint.deactivate(constraints)
    }
    
}
