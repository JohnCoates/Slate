//
//  InvertedMaskButtonViewController
//  Slate
//
//  Created by John Coates on 5/13/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

class InvertedMaskButtonViewController: UIViewController {
    
    // MARK: - Init
    
    enum Kind {
        case checkmark
        case flipCamera
        case buttonIndicatr
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
            button = InverseMaskButton(icon: CheckmarkIcon())
            width = 36
            heightRatio = 0.9429
        case .flipCamera:
            button = InverseMaskGroupedPathButton(icon: FlippedCameraIcon())
            width = 36
            heightRatio = 0.9429
        case .buttonIndicatr:
            view.backgroundColor = UIColor.white
            let icon = ButtonIndicatorIcon()
            let iconView = CanvasIconView(icon: icon)
            button = iconView
            button.backgroundColor = UIColor.clear
            width = 30
            heightRatio = icon.height / icon.width
        }
        
        view.addSubview(button)
        constrain(button) {
            let superview = $0.superview!
            $0.center == superview.center
            $0.width == width
            $0.height == $0.width * heightRatio
        }
    }
}
