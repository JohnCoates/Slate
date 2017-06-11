//
//  PhotosDeniedPermisionViewController.swift
//  Slate
//
//  Created by John Coates on 5/18/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class PhotosDeniedPermisionViewController: DeniedPermissionViewController {
    
    // MARK: - Configuration
    
    override func configureEducation() {
        configureButtons()
        
        educationImage = VectorImageCanvasIcon.from(asset: PermissionsImage.photos)
        educationImageSize = CGSize(width: 118, height: 102)
        
        explanation = "Slate needs access to your Photos to be able to save photos." +
        "You'll need to open Settings to allow access."
        
        self.explanation = explanation
    }
    
    override func setUpPreviewView() {
        privacyTogglePreviewText = "Photos"
        super.setUpPreviewView()
    }

}
