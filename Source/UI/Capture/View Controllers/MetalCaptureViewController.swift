//
//  MetalCaptureViewController.swift
//  Slate
//
//  Created by John Coates on 9/27/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit
import MetalKit
import AVFoundation
import CoreImage
import MobileCoreServices
import ImageIO

final class MetalCaptureViewController: BaseCaptureViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Setup
    
    lazy var metalView = MTKView()
    var renderer: Renderer?
    
    override func cameraSetup() {
        view.insertSubview(metalView, at: 0)
        metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        metalView.frame = view.bounds
        renderer = Renderer(metalView: metalView)
    }
    
    // MARK: - Capturing

    override func capture() {
        guard let renderer = renderer else {
            print("Missing renderer")
            return
        }
        
        let stillOutput = renderer.cameraController.stillOutput
    
        var videoConnectionMaybe: AVCaptureConnection?
        let connections = stillOutput.connections
        for connection in connections {
            let inputPorts = connection.inputPorts
            
            for port in inputPorts where port.mediaType == AVMediaType.video {
                videoConnectionMaybe = connection
                break
            }
            if videoConnectionMaybe != nil {
                break
            }
        }
        
        guard let videoConnection = videoConnectionMaybe else {
            print("Error: Couldn't find a video connection for output")
            return
        }
        
        stillOutput.captureStillImageAsynchronously(from: videoConnection) { sampleBuffer, error in
            guard let sampleBuffer = sampleBuffer, let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                print("Error: Can't save image, couldn't get image buffer")
                return
            }
            
            let image = CIImage(cvImageBuffer: imageBuffer)
            
            let data = NSMutableData()
            guard let destination = CGImageDestinationCreateWithData(data as CFMutableData, kUTTypeJPEG, 1, nil) else {
                print("Couldn't create image destination!")
                return
            }
            
            let conversionContext = CIContext(mtlDevice: renderer.device)
            guard let cgImage = conversionContext.createCGImage(image, from: image.extent) else {
                print("Couldn't convert image to CGImage")
                return
            }
            CGImageDestinationAddImage(destination, cgImage, nil)
            CGImageDestinationFinalize(destination)
            
            ImageCaptureManager.captured(imageData: data as Data)
        }
        
    }
    
    // MARK: - Camera Switching
    
    override func switchCamera() {
        renderer?.cameraController.switchToNextCamera()
    }
    
    // MARK: - Status Bar
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
        
}
