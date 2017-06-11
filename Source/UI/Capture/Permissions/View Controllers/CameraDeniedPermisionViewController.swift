//
//  CameraDeniedPermisionViewController
//  Slate
//
//  Created by John Coates on 5/17/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import AVFoundation

class CameraDeniedPermisionViewController: DeniedPermissionViewController {
    
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
    
    override func setUpPreviewView() {
        privacyTogglePreviewText = "Camera"
        super.setUpPreviewView()
    }
    
}
