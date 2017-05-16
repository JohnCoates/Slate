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
        if transform.a != 1 {
            let transformX = transform.a
            layer.cornerRadius = ((frame.width / transformX) / 2) * CGFloat(rounding)
        } else {
            layer.cornerRadius = (frame.width / 2) * CGFloat(rounding)
        }
    }
}
