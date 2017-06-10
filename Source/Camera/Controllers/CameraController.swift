//
//  CameraController.swift
//  Slate
//
//  Created by John Coates on 9/30/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import AVFoundation
#if os(iOS)
    import UIKit
#endif

class CameraController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Configuration
    
    typealias CaptureHandler = (CVImageBuffer) -> Void
    private var captureHandler: CaptureHandler?
    
    func setCaptureHandler<T: AnyObject>(instance: T,
                                         method: @escaping (T) -> CaptureHandler) {
        captureHandler = {
            [unowned instance] imageBuffer in
            method(instance)(imageBuffer)
        }
    }
    
    // MARK: - Init / Deinit
    
    deinit {
        session.stopRunning()
    }
    
    // MARK: - Session
    
    lazy var session = AVCaptureSession()
    
    // MARK: - Input 
    
    var inputSize: Size?
    
    // MARK: - Video Delegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!,
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
            
            captureHandler?(imageBuffer)
        #endif
    }
    
    // MARK: - Still Output
    
    lazy var stillOutput: AVCaptureStillImageOutput = self.buildStillOutput()
}
