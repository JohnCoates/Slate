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
    
    var icon: CanvasIcon?
    
    convenience init(asset: ImageAsset) {
        let icon = VectorImageCanvasIcon(asset: asset)
        self.init(icon: icon)
    }
    
    convenience init(icon: CanvasIcon) {
        self.init()
        self.icon = icon
    }
    
    init() {
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
        guard let icon = icon else {
            return
        }
        
        let canvasContentMode = CanvasIconContentMode.from(contentMode: contentMode)
        icon.draw(toTargetFrame: contentView.frame, contentMode: canvasContentMode)
    }
    
}
