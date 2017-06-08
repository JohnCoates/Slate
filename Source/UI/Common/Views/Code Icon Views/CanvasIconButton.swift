//
//  CanvasIconButton.swift
//  Slate
//
//  Created by John Coates on 6/7/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class CanvasIconButton: Button {
    
    // MARK: - Init
    
    let icon: CanvasIcon
    init(icon: CanvasIcon) {
        self.icon = icon
        super.init(frame: .zero)
        contentMode = .scaleAspectFit
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func initialSetup() {
        super.initialSetup()
        
        contentView.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let canvasContentMode = CanvasIconContentMode.from(contentMode: contentMode)
        icon.draw(toTargetFrame: contentView.frame, contentMode: canvasContentMode)
    }
}
