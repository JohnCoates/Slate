//
//  PhotosDeniedPermisionViewController.swift
//  Slate
//
//  Created by John Coates on 5/18/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class PhotosDeniedPermisionViewController: PermissionsEducationViewController {
    
    // MARK: - Configuration
    
    override func configureEducation() {
        configureButtons()
        
        educationImage = VectorImageCanvasIcon.from(asset: PermissionsImage.photos)
        educationImageSize = CGSize(width: 118, height: 102)
        
        explanation = "Slate needs access to your Photos to be able to save photos." +
        "You'll need to open Settings to allow access."
        
        self.explanation = explanation
    }
    
    func configureButtons() {
        var cameraRoll = DialogButton()
        cameraRoll.text = "Open Settings"
        cameraRoll.textColor = .white
        cameraRoll.backgroundColor = UIColor(red:0.28, green:0.39, blue:0.43, alpha:1.00)
        cameraRoll.tappedHandler = {[unowned self] in self.openSettings()}
        buttons.append(cameraRoll)
        
        var later = DialogButton()
        later.text = "Later"
        later.textColor = .white
        later.backgroundColor = UIColor(red:0.56, green:0.56, blue:0.56, alpha:1.00)
        later.tappedHandler = {[unowned self] in self.tappedLater()}
        
        buttons.append(later)
    }
    
    override func setUpPreviewView() {
        let preview = privacyCellPreview(withText: "Photos")
        
        UITapGestureRecognizer(addToView: preview) {  [unowned self] in
            self.openSettings()
        }
        
        previewView = preview
    }
    
    func openSettings() {
        guard let appSettingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
            fatalError("Couldn't get deep link to app settings")
        }
        
        UIApplication.shared.openURL(appSettingsURL)
    }
    
    func tappedLater() {
        PermissionsWindow.dismiss()
    }
}
