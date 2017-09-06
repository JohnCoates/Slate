//
//  CanvasIconView
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class CanvasIconView: UIView {
    
    // MARK: - Init

    convenience init(asset: ImageAsset) {
        let icon = VectorImageCanvasIcon(asset: asset)
        self.init(icon: icon)
    }
    
    var color: UIColor? {
        didSet {
            if let vectorIcon = icon as? VectorImageCanvasIcon {
                vectorIcon.customColor = color
            }
        }
    }
    
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
    
    private func initialSetup() {
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let canvasContentMode = CanvasIconContentMode.from(contentMode: contentMode)
        
        icon.draw(toTargetFrame: rect, contentMode: canvasContentMode)
    }
    
}
