//
//  PhotosPermissionViewController.swift
//  Slate
//
//  Created by John Coates on 5/17/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography
import AVFoundation
import Photos

fileprivate typealias LocalClass = PhotosPermissionViewController
class PhotosPermissionViewController: PermissionsEducationViewController {
    
    // MARK: - Configuration
    
    override func configureEducation() {
        super.configureEducation()
        configureButtons()
        
        educationImage = PhotosEducationImage()
        educationImageSize = CGSize(width: 118, height: 102)
        
        explanation = "Would you like your photos saved to the Camera Roll, or would you like them saved in this app only?"
    }
    
    func configureButtons() {
        var cameraRoll = DialogButton()
        cameraRoll.text = "Save them to my Camera Roll"
        cameraRoll.textColor = .white
        cameraRoll.backgroundColor = UIColor(red:0.18, green:0.71,
                                             blue:0.93, alpha:1.00)
        cameraRoll.tappedHandler = {[unowned self] in self.tappedCameraRoll()}
        buttons.append(cameraRoll)
        
        var appOnly = DialogButton()
        appOnly.text = "Save them in this app only"
        appOnly.textColor = UIColor(red:0.10, green:0.67,
                                    blue:0.94, alpha:1.00)
        appOnly.backgroundColor = UIColor(red:0.09, green:0.12,
                                          blue:0.15, alpha:1.00)
        appOnly.tappedHandler = {[unowned self] in self.tappedThisAppOnly()}
        buttons.append(appOnly)
    }
    
    
    // MARK: - Photos Access
    
    func requestAccessFromSystem() {
        // Doesn't return on main queue!
        PHPhotoLibrary.requestAuthorization { result in
            print("photos result: \(result)")
            DispatchQueue.main.async {
                if self.presentedViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
                PermissionsWindow.dismiss()
            }
        }
    }
    
    func showDeniedCameraRollScreen() {
        guard let appSettingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            fatalError("Couldn't get deep link to app settings")
        }
        let controller = UIAlertController(title: "\(appName) Needs Photos Access",
            message: "Enable Photos access in Settings to be able to save photos to your Camera Roll.",
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
    
    func tappedCameraRoll() {
        let status = PHPhotoLibrary.authorizationStatus()
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
            showDeniedCameraRollScreen()
            return
        }
        
        PermissionsPreferredButtonIndicatorController.attemptToPresentPreferredButtonIndicator(onViewController: self) {
            self.requestAccessFromSystem()
        }
    }
    
    func tappedThisAppOnly() {
        PermissionsWindow.dismiss()
    }
}
