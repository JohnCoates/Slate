//
//  AnchorOperators.swift
//  Slate
//
//  Created by John Coates on 6/6/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

// MARK: - Assignment

infix operator -->: LayoutAssignment
precedencegroup LayoutAssignment {
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}

func --> (lhs: LayoutAnchor<NSLayoutXAxisAnchor>, rhs: LayoutAnchor<NSLayoutXAxisAnchor>) {
    lhs.pin(to: rhs)
}

func --> (lhs: LayoutAnchor<NSLayoutYAxisAnchor>, rhs: LayoutAnchor<NSLayoutYAxisAnchor>) {
    lhs.pin(to: rhs)
}

func --> (lhs: LayoutDimensionAnchor, rhs: LayoutDimensionAnchor) {
    lhs.pin(to: rhs)
}

func --> (lhs: LayoutDimensionAnchor, rhs: CGFloat) {
    lhs.pin(to: rhs)
}

func --> (lhs: LayoutXYAnchor, rhs: LayoutXYAnchor) {
    lhs.pin(to: rhs)
}

func --> (lhs: Anchor<XAxis>, rhs: Anchor<XAxis>) {
    lhs.pin(to: rhs)
}

func --> (lhs: Anchor<YAxis>, rhs: Anchor<YAxis>) {
    lhs.pin(to: rhs)
}

func --> (lhs: Anchor<Dimension>, rhs: Anchor<Dimension>) {
    lhs.pin(to: rhs)
}

func --> (lhs: DimensionAnchor, rhs: CGFloat) {
    lhs.pin(to: rhs)
}

func --> (lhs: XYAnchor, rhs: XYAnchor) {
    lhs.pin(to: rhs)
}

// MARK: - Greater Or Equal To

infix operator -->+=: LayoutAtLeastAssignment
precedencegroup LayoutAtLeastAssignment {
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}

func -->+= (lhs: LayoutAnchor<NSLayoutXAxisAnchor>, rhs: LayoutAnchor<NSLayoutXAxisAnchor>) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: LayoutAnchor<NSLayoutYAxisAnchor>, rhs: LayoutAnchor<NSLayoutYAxisAnchor>) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: LayoutDimensionAnchor, rhs: LayoutDimensionAnchor) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: LayoutDimensionAnchor, rhs: CGFloat) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: LayoutXYAnchor, rhs: LayoutXYAnchor) {
    lhs.pin(atLeast: rhs)
}

//
func -->+= (lhs: Anchor<XAxis>, rhs: Anchor<XAxis>) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: Anchor<YAxis>, rhs: Anchor<YAxis>) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: DimensionAnchor, rhs: DimensionAnchor) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: DimensionAnchor, rhs: CGFloat) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: XYAnchor, rhs: XYAnchor) {
    lhs.pin(atLeast: rhs)
}
