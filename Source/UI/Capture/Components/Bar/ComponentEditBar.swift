//
//  ComponentEditBar.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Cartography

final class ComponentEditBar: UIView {
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        backgroundColor = UIColor(red:0.11, green:0.09,
                                  blue:0.11, alpha:0.44)
    }
    
    enum ProgressType {
        case size(range: Range<Float>)
        case rounding
    }
    
    var lastEditControl: UIView?
    var controls = [UIView]()
    func addProgressControl(type: ProgressType) {
        let minimumValue: Float
        let maximumValue: Float
        var units: String?
        let name: String
        
        switch type {
        case .size(let range):
            name = "Size"
            minimumValue = range.lowerBound
            maximumValue = range.upperBound
            units = "pt"
        case .rounding:
            name = "Rounding"
            minimumValue = 0
            maximumValue = 100
        }
        
        let control = ProgressCircleView()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.minimumValue = minimumValue
        control.maximumValue = maximumValue
        control.units = units
        control.valueChangedHandler = valueHandler(forType: type)

        addSubview(control)
        controls.append(control)
        
        constrain(control) {
            let superview = $0.superview!
            $0.width == 50
            $0.height == $0.width
            
            $0.left >= superview.leftMargin
            $0.centerY == superview.centerY
        }
        
        if let lastEditControl = lastEditControl {
            constrain(control, lastEditControl) { control, lastEditControl in
                control.left == lastEditControl.right + 20
            }
        }
        
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        label.textColor = UIColor.white
        label.text = name
        addSubview(label)
        controls.append(label)
        
        constrain(control, label) { control, label in
            label.centerX == control.centerX
            label.top == control.bottom + 2
        }
        
        lastEditControl = control
    }
    
    func valueHandler(forType type: ProgressType) -> ProgressCircleView.ValueChangedCallback {
        switch type {
        case .rounding:
            return roundingValueHandler()
        case .size(_):
            return sizeValueHandler()
        }
    }
    
    func roundingValueHandler() -> ProgressCircleView.ValueChangedCallback {
        return { value in
            if let circleView = self.targetView as? CircleView {
                circleView.roundingPercentage = value / 100
            }
        }
    }
    
    func sizeValueHandler() -> ProgressCircleView.ValueChangedCallback {
        return { value in
            guard let view = self.targetView else {
                return
            }
            
            view.frame.size.width = CGFloat(value)
            view.frame.size.height = CGFloat(value)
        }
    }
    
    var targetView: UIView?
    func set(target: Component) {
//        for control in controls {
//            control.removeFromSuperview()
//        }
        targetView = target.view
        lastEditControl = nil
        
        addProgressControl(type: .size(range: 12..<80))
        addProgressControl(type: .rounding)
    }
}
