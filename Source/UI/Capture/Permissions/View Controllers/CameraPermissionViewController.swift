//
//  CameraPermissionViewController.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import AVFoundation

fileprivate typealias LocalClass = CameraPermissionViewController
class CameraPermissionViewController: PermissionsEducationViewController {
    
    // MARK: - Configuration
    
    override func configureEducation() {
        configureButtons()
        
        educationImage = CameraEducationImage()
        educationImageSize = CGSize(width: 84, height: 102)
        
        explanation = "Slate needs access to your camera to be able to take photos."
    }
    
    func configureButtons() {
        var cameraRoll = DialogButton()
        cameraRoll.text = "Give Slate access"
        cameraRoll.textColor = .white
        cameraRoll.backgroundColor = UIColor(red:0.18, green:0.71, blue:0.93, alpha:1.00)
        cameraRoll.tappedHandler = {[unowned self] in self.tappedCameraAccess()}
        buttons.append(cameraRoll)
        
        var appOnly = DialogButton()
        appOnly.text = "Later"
        appOnly.textColor = .white
        appOnly.backgroundColor = UIColor(red:0.56, green:0.56, blue:0.56, alpha:1.00)
        appOnly.tappedHandler = {[unowned self] in self.tappedLater()}
        buttons.append(appOnly)
    }
    
    // MARK: - Camera Access
    
    func requestAccessFromSystem() {
        // Doesn't return on main queue!
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { authorized in
            DispatchQueue.main.async {
                if self.presentedViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
                PermissionsWindow.dismiss()
                if authorized {
                    self.delegate?.enabled(permission: .camera)
                } else {
                    self.delegate?.denied(permission: .camera)
                }
            }
        }
    }
    
    func showDeniedCameraScreen() {
        present(CameraDeniedPermisionViewController(), animated: true, completion: nil)
    }
    
    // MARK: - User Interaction
    
    func tappedCameraAccess() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .notDetermined:
            break
        case .authorized:
            PermissionsWindow.dismiss()
            return
        case .denied, .restricted:
            print("denied")
            showDeniedCameraScreen()
            return
        }
        
        PermissionsPreferredButtonIndicatorController.attemptToPresentPreferredButtonIndicator(onViewController: self) {
            self.requestAccessFromSystem()
        }
    }
    
    func tappedLater() {
        PermissionsWindow.dismiss()
    }
}
