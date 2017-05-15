//
//  PathIcon.swift
//  Slate
//
//  Created by John Coates on 5/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

protocol PathIcon {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var path: CGPath { get }
}
