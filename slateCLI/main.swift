//
//  main.swift
//  slateCLI
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

let images: [VectorImageAsset] = [
    DrawProxyDSL.KitSettingsImage(),
    DrawProxyDSL.CameraPermissionsImage()
]

var canvases = [Canvas]()
for image in images {
    DrawProxyDSL.pushCanvas(name: image.name, section: image.section,
                            width: Float(image.width), height: Float(image.height))
    image.simulateDraw()
    let canvas = DrawProxyDSL.popCanvas()
    canvases.append(canvas)
}

let writer = VectorImage.Writer.init(canvases: canvases)
writer.write(toFile: URL(fileURLWithPath: "/tmp/image.vif"))
writer.write(toFile: URL(fileURLWithPath: "/tmp/image.cvif"), compressed: true)
