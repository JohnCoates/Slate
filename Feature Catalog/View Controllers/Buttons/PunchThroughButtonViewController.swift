//
//  PunchThroughButtonViewController.swift
//  Slate
//
//  Created by John Coates on 5/13/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

class PunchThroughButtonViewController: UIViewController {
    
    // MARK: - Init
    
    init() {
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
        
        let punchOut = PunchOutView()
        
        view.addSubview(punchOut)
        constrain(punchOut) {
            let superview = $0.superview!
            $0.center == superview.center
            $0.width == 36
            $0.height == $0.width * 0.9429
        }
        
    }
}
