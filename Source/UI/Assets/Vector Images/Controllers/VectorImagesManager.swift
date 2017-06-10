//
//  VectorImagesManager.swift
//  Slate
//
//  Created by John Coates on 6/9/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation

class VectorImagesManager {
    var canvases = [Canvas]()
    var keyedCanvases = [String: Canvas]()
    var readFiles = [ImageFile]()
    
    static let shared = VectorImagesManager.init()
    
    private init() {
    }
    
    private func ingestIfNecessary(file: ImageFile) -> Bool {
        if readFiles.contains(file) {
           return true
        }
        
        let filename = file.rawValue
        guard let file = Bundle.main.url(forResource: filename, withExtension: "") else {
            fatalError("Couldn't find core assets file!")
        }
        
        do {
            let reader = try VectorAssetReader(file: file)
            try reader.read()
            for canvas in reader.canvases {
                canvases.append(canvas)
                keyedCanvases[canvas.identifier] = canvas
            }
            
        } catch let error {
            print("Error reading vector assets: \(error)")
            return false
        }
        
        return true
    }    
    
    fileprivate func requiredCanvas(fromAsset asset: ImageAsset) -> Canvas {
        if !ingestIfNecessary(file: asset.file) {
            fatalError("Couldn't load asset \(asset.identifier), failed to ingest file")
        }
        
        guard let canvas = keyedCanvases[asset.identifier] else {
            fatalError("Missing asset \(asset.identifier) from keyed canvases")
        }
        
        return canvas
    }
}

extension Canvas {
    static func from(asset: ImageAsset) -> Canvas {
        return VectorImagesManager.shared.requiredCanvas(fromAsset: asset)
    }
}

extension VectorImageCanvasIcon {
    static func from(asset: ImageAsset) -> VectorImageCanvasIcon {
        let canvas = Canvas.from(asset: asset)
        return VectorImageCanvasIcon(canvas: canvas)
    }
}
