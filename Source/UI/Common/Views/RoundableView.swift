//
//  RoundableView.swift
//  Slate
//
//  Created by John Coates on 5/14/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class RoundableView: UIView {
    var rounding: Float = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = (frame.width / 2) * CGFloat(rounding)
    }
}
