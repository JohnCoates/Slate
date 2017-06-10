//
//  CameraDeniedPermisionViewController
//  Slate
//
//  Created by John Coates on 5/17/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import AVFoundation

class CameraDeniedPermisionViewController: PermissionsEducationViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Configuration
    
    override func configureEducation() {
        configureButtons()
        
        let image = VectorImageCanvasIcon.from(asset: PermissionsImage.camera)
        educationImage = image
        educationImageSize = image.size
        
        explanation = "Slate needs access to your camera to be able to take photos. " +
        "You'll need to open Settings to allow access."
        
        self.explanation = explanation
    }
    
    func configureButtons() {
        var cameraRoll = DialogButton()
        cameraRoll.text = "Open Settings"
        cameraRoll.textColor = .white
        cameraRoll.backgroundColor = UIColor(red: 0.28, green: 0.39, blue: 0.43, alpha: 1.00)
        cameraRoll.tappedHandler = {[unowned self] in self.openSettings()}
        buttons.append(cameraRoll)
        
        var later = DialogButton()
        later.text = "Later"
        later.textColor = .white
        later.backgroundColor = UIColor(red: 0.56, green: 0.56, blue: 0.56, alpha: 1.00)
        later.tappedHandler = {[unowned self] in self.tappedLater()}
        
        buttons.append(later)
    }
    
    override func setUpPreviewView() {
        let preview = privacyCellPreview(withText: "Camera")
        
        UITapGestureRecognizer(addToView: preview) {  [unowned self] in
            self.openSettings()
        }
        
        previewView = preview
    }
    
    func openSettings() {
        guard let appSettingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            fatalError("Couldn't get deep link to app settings")
        }
        
        subscribeToApplicationDidBecomeActive()
        UIApplication.shared.openURL(appSettingsURL)
    }
    
    func tappedLater() {
        PermissionsWindow.dismiss()
    }
    
    // MARK: - Respond To Changes
    
    func subscribeToApplicationDidBecomeActive() {
        let name = NSNotification.Name.UIApplicationDidBecomeActive
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive),
                                               name: name, object: nil)
    }
    
    func applicationDidBecomeActive() {
        DispatchQueue.main.async {
            self.checkApprovalStatus()
        }
    }
    
    func checkApprovalStatus() {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case .notDetermined:
            // This shouldn't happen
            present(CameraPermissionViewController(), animated: true, completion: nil)
            break
        case .authorized:
            // Tested on iOS 10 this never gets called, since Settings actually terminates
            // the app when the permission is toggled
            PermissionsWindow.dismiss()
            return
        case .denied, .restricted:
            return
        }
    }
    
}
