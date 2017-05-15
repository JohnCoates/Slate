//
//  MetalCameraController.swift
//  Slate
//
//  Created by John Coates on 10/1/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AVFoundation
import Metal
#if os(iOS)
    import UIKit
#endif

class MetalCameraController: CameraController {
    
    // MARK: - Configuration
    
    typealias TextureHandler = (MTLTexture) -> Void
    private var textureHandler: TextureHandler?
    func setTextureHandler<T: AnyObject>(instance: T,
                                         method: @escaping (T) -> TextureHandler) {
        textureHandler = {
            [unowned instance] texture in
            method(instance)(texture)
        }
    }
    
    // MARK: - Init
    
    #if METAL_DEVICE
    let textureCache: CVMetalTextureCache
    #endif
    init?(device: MTLDevice) {
        #if METAL_DEVICE
        var optionalTextureCache: CVMetalTextureCache?
        guard CVMetalTextureCacheCreate(kCFAllocatorDefault,
                                        nil, // cache attributes
            device,
            nil, // texture attributes
            &optionalTextureCache) == kCVReturnSuccess,
        let textureCache = optionalTextureCache else {
                print("Couldn't create a texture cache")
                return nil
        }
        
        self.textureCache = textureCache
        #endif
    }    
    
    // MARK: - Video Delegate
    
    override func captureOutput(_ captureOutput: AVCaptureOutput!,
                                didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                                from connection: AVCaptureConnection!) {
        #if METAL_DEVICE
            #if os(iOS)
                let orientation = UIApplication.shared.statusBarOrientation.rawValue
                connection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientation)!
            #endif
            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                print("Couldn't get image buffer")
                return
            }
            
            var optionalTextureRef: CVMetalTexture? = nil
            let width = CVPixelBufferGetWidth(imageBuffer)
            let height = CVPixelBufferGetHeight(imageBuffer)
            let returnValue = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                        textureCache,
                                                                        imageBuffer,
                                                                        nil,
                                                                        .bgra8Unorm,
                                                                        width, height, 0,
                                                                        &optionalTextureRef)
            
            guard returnValue == kCVReturnSuccess, let textureRef = optionalTextureRef else {
                print("Error, couldn't create texture from image, error: \(returnValue), \(optionalTextureRef)")
                return
            }
            
            guard let texture = CVMetalTextureGetTexture(textureRef) else {
                print("Error, Couldn't get texture")
                return
            }
            
            textureHandler?(texture)
        #endif
    }
}
