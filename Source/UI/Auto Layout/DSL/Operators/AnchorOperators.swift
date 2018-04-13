//
//  AnchorOperators.swift
//  Slate
//
//  Created by John Coates on 6/6/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import CoreGraphics

// MARK: - Assignment

infix operator -->: LayoutAssignment
precedencegroup LayoutAssignment {
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}

func --> <Kind>(lhs: Anchor<Kind>, rhs: Anchor<Kind>) {
    lhs.pin(to: rhs)
}

func --> (lhs: DimensionAnchor, rhs: CGFloat) {
    lhs.pin(to: rhs)
}

func --> (lhs: XYAnchor, rhs: XYAnchor) {
    lhs.pin(to: rhs)
}

func --> (lhs: SizeAnchor, rhs: SizeAnchor) {
    lhs.pin(to: rhs)
}

func --> (lhs: SizeAnchor, rhs: CGSize) {
    lhs.pin(to: rhs)
}

func --> (lhs: EdgesAnchor, rhs: EdgesAnchor) {
    lhs.pin(to: rhs)
}

// Views

func --> <Kind>(lhs: Anchor<Kind>, rhs: View) {
    lhs.pin(to: rhs)
}

func --> (lhs: XYAnchor, rhs: View) {
    lhs.pin(to: XYAnchor(target: rhs, kind: lhs.kind))
}

func --> (lhs: SizeAnchor, rhs: View) {
    lhs.pin(to: SizeAnchor(target: rhs))
}

func --> (lhs: EdgesAnchor, rhs: View) {
    lhs.pin(to: EdgesAnchor(target: rhs))
}

func --> (lhs: LayoutAnchors, rhs: View) {
    for attribute in lhs.attributes {
        let left = Anchor<AnchorType>(target: lhs.target, kind: attribute)
        let right = Anchor<AnchorType>(target: rhs, kind: attribute)
        
        left.pin(to: right)
    }
}

// MARK: - Greater Than Or Equal To

infix operator -->+=: LayoutAtLeastAssignment
precedencegroup LayoutAtLeastAssignment {
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}

func -->+= <Kind>(lhs: Anchor<Kind>, rhs: Anchor<Kind>) {
    lhs.pin(atLeast: rhs)
}

func -->+= <Kind>(lhs: Anchor<Kind>, rhs: View) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: DimensionAnchor, rhs: DimensionAnchor) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: DimensionAnchor, rhs: View) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: DimensionAnchor, rhs: CGFloat) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: XYAnchor, rhs: XYAnchor) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: SizeAnchor, rhs: SizeAnchor) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: SizeAnchor, rhs: View) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: SizeAnchor, rhs: CGSize) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: EdgesAnchor, rhs: EdgesAnchor) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: EdgesAnchor, rhs: View) {
    lhs.pin(atLeast: rhs)
}

func -->+= (lhs: LayoutAnchors, rhs: View) {
    for attribute in lhs.attributes {
        let left = Anchor<AnchorType>(target: lhs.target, kind: attribute)
        let right = Anchor<AnchorType>(target: rhs, kind: attribute)
        
        left.pin(atLeast: right)
    }
}

// MARK: - Less Than Or Equal To

infix operator -->-=: LayoutAtMostAssignment
precedencegroup LayoutAtMostAssignment {
    lowerThan: AdditionPrecedence
    higherThan: AssignmentPrecedence
}

func -->-= <Kind>(lhs: Anchor<Kind>, rhs: Anchor<Kind>) {
    lhs.pin(atMost: rhs)
}

func -->-= <Kind>(lhs: Anchor<Kind>, rhs: View) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: DimensionAnchor, rhs: DimensionAnchor) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: DimensionAnchor, rhs: View) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: SizeAnchor, rhs: View) {
    lhs.pin(atLeast: rhs)
}

func -->-= (lhs: DimensionAnchor, rhs: CGFloat) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: XYAnchor, rhs: XYAnchor) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: SizeAnchor, rhs: SizeAnchor) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: SizeAnchor, rhs: CGSize) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: EdgesAnchor, rhs: EdgesAnchor) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: EdgesAnchor, rhs: View) {
    lhs.pin(atMost: rhs)
}

func -->-= (lhs: LayoutAnchors, rhs: View) {
    for attribute in lhs.attributes {
        let left = Anchor<AnchorType>(target: lhs.target, kind: attribute)
        let right = Anchor<AnchorType>(target: rhs, kind: attribute)
        
        left.pin(atMost: right)
    }
}
