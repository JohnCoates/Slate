//
//  AutoLayoutAnchorTests
//  Created on 4/13/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import XCTest
#if os(iOS)
@testable import Slate
#else
@testable import macSlate
#endif

class AutoLayoutAnchorTests: XCTestCase {
    
    var parentView = UIView()
    var childView = UIView()
    var views: [UIView] = []
    let constants: [CGFloat] = [20, 30]
    
    override func setUp() {
        super.setUp()
        parentView = UIView()
        childView = UIView()
        parentView.addSubview(childView)
        views = [parentView, childView]
    }
    
    func testInit() {
        let viewController = UIViewController()
        viewController.view.addSubview(childView)
        
        if #available(iOS 11.0, *) {
            XCTAssertNoThrow(self.childView.top --> viewController.view.safeAreaLayoutGuide.top)
        }
        XCTAssertNoThrow(childView.bottom --> viewController.topLayoutGuide.bottom)
    }
    
    func testCellHandling() {
        let cell = UITableViewCell()
        cell.contentView.width --> 50
        XCTAssertEqual(cell.contentView.translatesAutoresizingMaskIntoConstraints, true)
    }
    
    func testRemoveConstraints() {
        XCTAssertFalse(UILayoutGuide().width.removeExisting())
        XCTAssertNil(UILayoutGuide().width.existing)
        XCTAssertFalse(childView.width.removeExisting())
        
        XCTAssertNil(childView.width.existing)
        childView.widthAnchor.constraint(equalTo: parentView.heightAnchor).isActive = true
        XCTAssertNil(childView.width.existing)
        
        parentView.width --> childView.height
        XCTAssertNil(childView.width.existing)
        
        childView.height --> 200
        XCTAssertNil(childView.width.existing)
        
        childView.width --> 100
        XCTAssertNotNil(childView.width.existing)
        
        XCTAssertTrue(childView.width.removeExisting())
    }
}
