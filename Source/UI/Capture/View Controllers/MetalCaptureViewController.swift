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
    
    // MARK: - Init
    
    required init(kit: Kit) {
        super.init(kit: kit)
        RotationManager.beginOrientationEvents()
    }
    
    required init(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    deinit {
        RotationManager.endOrientationEvents()
    }
    
    // MARK: - Setup
    
    lazy var metalView = MTKView()
    var renderer: Renderer?
    
    override func cameraSetup() {
        view.insertSubview(metalView, at: 0)
        metalView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        metalView.frame = view.bounds
        renderer = Renderer(kit: kit, metalView: metalView)
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
            guard let sampleBuffer = sampleBuffer else {
                print("Error: Can't save image, nil sample buffer")
                return
            }
            
            guard CMSampleBufferIsValid(sampleBuffer) else {
                print("Error: invalid sample buffer")
                return
            }
            
//            CFDictionaryRef exifAttachments =
//                CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
//            if (exifAttachments) {
//                // Do something with the attachments.
//            }

            guard let imageData = self.getJpeg(from32BGRA: sampleBuffer) else {
                print("Error: Failed to save image.")
                return
            }
            
            ImageCaptureManager.captured(imageData: imageData)
        }
        
    }
    
    private func jpeg(from buffer: CMSampleBuffer) -> Data? {
        return AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
    }
    
    @available (iOS 11.0, *)
    private func jpegPhoto(from buffer: CMSampleBuffer) -> Data? {
        return AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer,
                                                                previewPhotoSampleBuffer: nil)
    }
    
    private func getJpeg(from32BGRA buffer: CMSampleBuffer) -> Data? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            print("Error: Couldn't get image buffer")
            return nil
        }
        guard let renderer = renderer else {
            print("Error: Missing renderer")
            return nil
        }
        
        let image = CIImage(cvImageBuffer: imageBuffer)
        
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data as CFMutableData, kUTTypeJPEG, 1, nil) else {
            print("Couldn't create image destination!")
            return nil
        }
        
        let conversionContext = CIContext(mtlDevice: renderer.device)
        guard let cgImage = conversionContext.createCGImage(image, from: image.extent) else {
            print("Couldn't convert image to CGImage")
            return nil
        }
        
        var properties: [CFString: Any] = [
            kCGImageDestinationMergeMetadata: 1
        ]
        
        let phoneOrientation = RotationManager.orientation
        let orientation: Int
        switch phoneOrientation {
        case .landscapeRight:
            orientation = 3
        case .portrait:
            orientation = 6
        case .portraitUpsideDown:
            orientation = 8
        case .landscapeLeft:
            fallthrough
        default:
            orientation = 1
        }
        properties[kCGImagePropertyOrientation] = orientation
        CGImageDestinationAddImage(destination, cgImage, properties as NSDictionary)
        CGImageDestinationFinalize(destination)
        return data as Data
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
