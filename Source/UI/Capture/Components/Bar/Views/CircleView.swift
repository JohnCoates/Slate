//
//  CircleView.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class CircleView: UIView {
    var roundingPercentage: Float = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = (frame.width / 2) * CGFloat(roundingPercentage)
    }
}
