//
//  ControlBarItemCell.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import Foundation
import Cartography

final class ControlBarItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ControlBarItemCell"
    
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
    
    let control = FrontBackCameraToggle()
    private func initialSetup() {
        backgroundColor = UIColor.green.withAlphaComponent(0.1)
        
        contentView.addSubview(control)
        constrain(control) {
            let superview = $0.superview!
            $0.width == superview.width
            $0.height == superview.height
        }
        
        setUpTapAndHoldGesture()
    }
    
    // MARK: - Drag & Drop
    
    func setUpTapAndHoldGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: .longPressed)
        gesture.minimumPressDuration = 0.2
        control.addGestureRecognizer(gesture)
    }
    
    fileprivate var lastLocation: CGPoint?
    func longPressed(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began || gesture.state == .ended || gesture.state == .cancelled {
            lastLocation = nil
        }
        
        let location = gesture.location(in: self)
        
        var difference = CGPoint.zero
        if let lastLocation = lastLocation {
            difference.x = location.x - lastLocation.x
            difference.y = location.y - lastLocation.y
        }
        lastLocation = location
        
        if gesture.state == .began {
            var frame = control.frame
            frame.size.width *= 1.3
            frame.size.height *= 1.3
            control.frame = frame
            return
        }
        
        let minimumChange: CGFloat = 1
        let xMeetsMinimum = abs(difference.x) > minimumChange
        let yMeetsMinimum = abs(difference.y) > minimumChange
        let bothMeetMinimum = abs(difference.x) + abs(difference.y) > minimumChange
        let somethingMeetsMiniumChange = xMeetsMinimum || yMeetsMinimum || bothMeetMinimum
        
        guard somethingMeetsMiniumChange else {
                return
        }
        
        var frame = control.frame
        frame.origin.x += difference.x
        frame.origin.y += difference.y
        control.frame = frame
    }
}

// MARK: - Selector Extension

private extension Selector {
    static let longPressed = #selector(ControlBarItemCell.longPressed(gesture:))
}
