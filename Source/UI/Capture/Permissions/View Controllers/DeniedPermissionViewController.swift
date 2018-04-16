//
//  DeniedPermissionViewController.swift
//  Slate
//
//  Created by John Coates on 6/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class DeniedPermissionViewController: PermissionsEducationViewController {
    
    // MARK: - Configuration
    
    func configureButtons() {
        var openSettings = DialogButton()
        openSettings.text = "Open Settings"
        openSettings.textColor = .white
        openSettings.backgroundColor = UIColor(red: 0.28, green: 0.39, blue: 0.43, alpha: 1.00)
        openSettings.tappedHandler = { [unowned self] in self.openSettings() }
        buttons.append(openSettings)
        
        var later = DialogButton()
        later.text = "Later"
        later.textColor = .white
        later.backgroundColor = UIColor(red: 0.56, green: 0.56, blue: 0.56, alpha: 1.00)
        later.tappedHandler = { [unowned self] in self.tappedLater() }
        
        buttons.append(later)
    }
    
    var privacyTogglePreviewText = "Override This"
    
    override func setUpPreviewView() {
        let preview = privacyCellPreview(withText: privacyTogglePreviewText)
        
        UITapGestureRecognizer(addToView: preview) { [unowned self] in
            self.openSettings()
        }
        
        previewView = preview
    }
    
    lazy var application = UIApplication.shared
    
    func openSettings() {
        let appSettingsURL = Critical.unwrap(URL(string: UIApplicationOpenSettingsURLString))
        
        application.openURL(appSettingsURL)
    }
    
    func tappedLater() {
        PermissionsWindow.dismiss()
    }
    
}
