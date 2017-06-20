//
//  CircleView.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class CircleView: RoundableView {
    
    var roundingPercentage: Float {
        set {
            rounding = newValue
        }
        get {
            return rounding
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rounding = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
