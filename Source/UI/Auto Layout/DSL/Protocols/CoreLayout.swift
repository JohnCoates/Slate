//
//  CoreLayout.swift
//  Slate
//
//  Created by John Coates on 6/6/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// swiftlint:disable identifier_name

import UIKit

protocol CoreLayout: class {
    associatedtype AnchorType: AnyObject
    
    func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint
    
    func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>) -> NSLayoutConstraint
    
    func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) -> NSLayoutConstraint
}

protocol CoreDimensionLayout: class, CoreLayout {
    func constraint(equalToConstant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(greaterThanOrEqualToConstant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(lessThanOrEqualToConstant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(equalTo anchor: NSLayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint
    
    func constraint(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat) -> NSLayoutConstraint
    func constraint(equalTo anchor: NSLayoutDimension, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(greaterThanOrEqualTo anchor: NSLayoutDimension,
                    multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint
    
    func constraint(lessThanOrEqualTo anchor: NSLayoutDimension,
                    multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint
    
}

extension NSLayoutXAxisAnchor: CoreLayout { }
extension NSLayoutYAxisAnchor: CoreLayout { }
extension NSLayoutDimension: CoreDimensionLayout { }
