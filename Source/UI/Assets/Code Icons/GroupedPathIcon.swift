//
//  GroupedPathIcon.swift
//  Slate
//
//  Created by John Coates on 5/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

protocol GroupedPathIcon {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var paths: [CGPath] { get }
}
