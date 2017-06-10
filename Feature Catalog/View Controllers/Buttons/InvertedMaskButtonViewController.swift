//
//  InvertedMaskButtonViewController
//  Slate
//
//  Created by John Coates on 5/13/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class InvertedMaskButtonViewController: UIViewController {
    
    // MARK: - Init
    
    enum Kind {
        case checkmark
        case flipCamera
        case buttonIndicator
    }
    
    let kind: Kind
    init(kind: Kind) {
        self.kind = kind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class is not NSCoder compliant")
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        view.backgroundColor = UIColor.black
        
        let button: UIView
        let width: CGFloat
        let heightRatio: CGFloat
        
        switch kind {
        case .checkmark:
            button = InverseMaskButtonImage(asset: EditingImage.checkmark)
            width = 36
            heightRatio = 0.9429
        case .flipCamera:
            button = InverseMaskButtonImage(asset: KitComponent.switchCamera)
            width = 36
            heightRatio = 0.9429
        case .buttonIndicator:
            view.backgroundColor = UIColor.white
            let icon = ButtonIndicatorIcon()
            let iconView = CanvasIconView(icon: icon)
            button = iconView
            button.backgroundColor = UIColor.clear
            width = 30
            heightRatio = icon.height / icon.width
        }
        
        view.addSubview(button)
        
        button.centerXY --> view.centerXY
        button.width --> width
        button.height.pin(to: button.width, times: heightRatio)
    }
}
