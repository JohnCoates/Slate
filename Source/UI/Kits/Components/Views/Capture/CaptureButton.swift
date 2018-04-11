//
//  CaptureButton.swift
//  Slate
//
//  Created by John Coates on 9/26/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

class CaptureButton: Button {
    
    // MARK: - Setup
    
    override func initialSetup() {
        super.initialSetup()
        contentView.backgroundColor = UIColor.white
        accessibilityIdentifier = "CaptureButton"
    }
    
}
