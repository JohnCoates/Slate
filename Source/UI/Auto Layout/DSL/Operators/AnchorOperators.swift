//
//  AnchorOperators.swift
//  Slate
//
//  Created by John Coates on 6/6/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

func == (lhs: LayoutAnchor<NSLayoutXAxisAnchor>, rhs: LayoutAnchor<NSLayoutXAxisAnchor>) {
    lhs.pin(to: rhs)
}

func == (lhs: LayoutAnchor<NSLayoutYAxisAnchor>, rhs: LayoutAnchor<NSLayoutYAxisAnchor>) {
    lhs.pin(to: rhs)
}

func == (lhs: LayoutDimensionAnchor, rhs: LayoutDimensionAnchor) {
    lhs.pin(to: rhs)
}

func == (lhs: LayoutDimensionAnchor, rhs: CGFloat) {
    lhs.pin(to: rhs)
}

infix operator ==: LayoutAssignment
precedencegroup LayoutAssignment {
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}
