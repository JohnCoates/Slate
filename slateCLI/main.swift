//
//  main.swift
//  slateCLI
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

DrawProxyDSL.target()

guard let canvas = DrawProxyDSL.canvas else {
    fatalError("Invalid canvas")
}

let writer = ImageWriter.init(canvases: [canvas])
writer.write()
