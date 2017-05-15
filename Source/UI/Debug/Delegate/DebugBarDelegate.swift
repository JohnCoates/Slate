//
//  DebugBarDelegate.swift
//  Slate
//
//  Created by John Coates on 12/28/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation

protocol DebugBarDelegate: class {
    var barItems: [DebugBarItem] { get }
}
