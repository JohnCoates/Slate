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
        backgroundColor = UIColor.white
        alpha = 0.56
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}
