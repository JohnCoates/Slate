//
//  CircleSlider.swift
//  Slate
//
//  Created by John Coates on 5/11/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

final class CircleSlider: UIView {
    
    // MARK: - Properties
    
    var value: Float = 12 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var minimumValue: Float = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var maximumValue: Float = 44.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    typealias ValueChangedCallback = ((_ value: Float) -> Void)
    var valueChangedHandler: ValueChangedCallback?
    /// setCallback(self, class.method)
    
    func setValueChangedHandler<T: AnyObject>(instance: T,
                                              method: @escaping (T) -> ValueChangedCallback) {
        valueChangedHandler = {
            [unowned instance] (_ value: Float) in
            method(instance)(value)
        }
    }
    
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
    
    let innerCircle = CircleView()
    private func initialSetup() {
        innerCircle.backgroundColor = UIColor(red: 0.16, green: 0.14, blue: 0.17, alpha: 1.00)
        addSubview(innerCircle)
        
        setUpProgressCircle()
        setUpPanGesture()
        setUpValueLabel()
    }
    
    let progressCircle = CAShapeLayer()
    static let defaultProgressStrokeWith: CGFloat = 4
    var progressStrokeWidth: CGFloat = 4 {
        didSet {
            progressCircle.lineWidth = progressStrokeWidth
        }
    }
    
    private var percentageValue: Float {
        var zeroValue: Float = 0
        if minimumValue > 0 {
            zeroValue = 0.05
        }
        
        if value <= minimumValue {
            return zeroValue
        } else if value >= maximumValue {
            return 1
        }
        
        let current = value - minimumValue
        let relativeMaximum = maximumValue - minimumValue
        let percentage = current / relativeMaximum
        return max(zeroValue, percentage)
    }
    
    private func setUpProgressCircle() {
        progressCircle.strokeColor = UIColor(red: 0.16, green: 0.55, blue: 0.79, alpha: 1.00).cgColor
        progressCircle.fillColor = UIColor.clear.cgColor
        progressCircle.lineWidth = progressStrokeWidth
        progressCircle.strokeStart = 0
        progressCircle.strokeEnd  = 1
        innerCircle.layer.addSublayer(progressCircle)
    }
    
    let valueLabel = UILabel(frame: .zero)
    var units: String? = "px"
    private func setUpValueLabel() {
        valueLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        valueLabel.textColor = UIColor.white
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.numberOfLines = 2
        valueLabel.textAlignment = .center
        innerCircle.addSubview(valueLabel)
        
        valueLabel.centerXY --> innerCircle.centerXY
    }
    
    private func updateLabel() {
        let valueInt = Int(value)
        var text = "\(valueInt)"
        if let units = units {
            text += "\n\(units)"
        }
        
        valueLabel.text = text
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        updateLabel()
        super.layoutSubviews()
        
        var innerFrame = self.bounds
        innerFrame.size.width -= progressStrokeWidth * 2
        innerFrame.size.height -= progressStrokeWidth * 2
        innerCircle.frame = innerFrame
        innerCircle.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let center = CGPoint (x: innerFrame.width / 2,
                              y: innerFrame.height / 2)
        let circleRadius = (innerFrame.width / 2) + (progressStrokeWidth / 2)
        let startAngleFactor: Float = 1.5
        let startAngle: Float = Float.pi * startAngleFactor
        let endAngle: Float = startAngleFactor + (2 * percentageValue)
        
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: circleRadius,
                                      startAngle: CGFloat(startAngle),
                                      endAngle: CGFloat(Float.pi * endAngle),
                                      clockwise: true)
        progressCircle.path = circlePath.cgPath
    }
    
    static func defaultInnerWidth(withOuterWidth outerWidth: CGFloat) -> CGFloat {
        return outerWidth - defaultProgressStrokeWith * 2
    }
    
    // MARK: - Adjust Gesture
    
    private func setUpPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: .pan)
        addGestureRecognizer(panGesture)
    }
    
    fileprivate var lastTranslation: CGPoint?
    @objc func pan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .ended || gesture.state == .cancelled {
            lastTranslation = nil
        }
        guard gesture.state == .changed else {
            return
        }
        
        let translation = gesture.translation(in: self)
        var difference = CGPoint.zero
        
        if let lastTranslation = lastTranslation {
            difference.y = translation.y - lastTranslation.y
            difference.x = translation.x - lastTranslation.x
        }
        let dominantDifference: CGFloat
        if abs(difference.x) > abs(difference.y) {
            dominantDifference = difference.x
        } else {
            dominantDifference = -difference.y
        }
        
        // it takes one third of the screen to go through the entire range
        let thirdOfScreen = Float(UIScreen.main.bounds.width / 3)
        let factor: Float = (maximumValue - minimumValue) / thirdOfScreen
        let valueChange = Float(dominantDifference) * factor
        var newValue = value + valueChange
        newValue = min(newValue, maximumValue)
        newValue = max(newValue, minimumValue)
        value = newValue
        
        valueChangedHandler?(value)
        
        lastTranslation = translation
    }

}
// MARK: - Selector Extension

private extension Selector {
    static let pan = #selector(CircleSlider.pan)
}
