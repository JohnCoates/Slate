//
//  PermissionsButtonIndicatorViewController.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

class PermissionsButtonIndicatorViewController: UIViewController {
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class is not NSCoder compliant")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUpViews()
    }
    
    var okayButtonPlaceholder = UIView(frame: .zero)
    
    let indicator = CanvasIconView(icon: ButtonIndicatorIcon())
    func setUpViews() {
//        okayButtonPlaceholder.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        okayButtonPlaceholder.isHidden = true
        view.addSubview(okayButtonPlaceholder)
        view.addSubview(indicator)
        
        let heightRatio = indicator.icon.height / indicator.icon.width
        constrain(indicator, okayButtonPlaceholder) { indicator, okayButtonPlaceholder in
            indicator.centerX == okayButtonPlaceholder.centerX
            indicator.top == okayButtonPlaceholder.bottom + 12
            indicator.width == 20
            indicator.height == indicator.width * heightRatio
        }
    }
}
