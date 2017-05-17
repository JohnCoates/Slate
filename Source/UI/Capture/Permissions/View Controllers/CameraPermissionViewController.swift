//
//  CameraPermissionViewController.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography
import AVFoundation

fileprivate typealias LocalClass = CameraPermissionViewController
class CameraPermissionViewController: PermissionsEducationViewController {
    
    // MARK: - Configuration
    
    override func configureEducation() {
        super.configureEducation()
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
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { result in
            DispatchQueue.main.async {
                if self.presentedViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
                PermissionsWindow.dismiss()
            }
        }
    }
    
    func showDeniedCameraScreen() {
        guard let appSettingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            fatalError("Couldn't get deep link to app settings")
        }
        let controller = UIAlertController(title: "\(appName) Needs Camera Access",
            message: "Please enable Camera access in Settings to continue.",
            preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)
        
        let openSettings = UIAlertAction(title: "Settings", style: .default) { alertAction in
            UIApplication.shared.openURL(appSettingsURL)
        }
        controller.addAction(openSettings)
        controller.preferredAction = openSettings
        
        present(controller, animated: true, completion: nil)
    }

    
    // MARK: - User Interaction
    
    func tappedCameraAccess() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .notDetermined:
            print("not determined")
            break
        case .authorized:
            print("authorized")
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
