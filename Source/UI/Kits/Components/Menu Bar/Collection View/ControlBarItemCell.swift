//
//  ControlBarItemCell.swift
//  Slate
//
//  Created by John Coates on 5/10/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

final class ControlBarItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ControlBarItemCell"
    weak var collectionView: UICollectionView?
    weak var delegate: ComponentItemCellDelegate?
    var component: Component.Type?
    
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
    
    var control: UIView? {
        didSet(oldControl) {
            if let oldControl = oldControl {
                oldControl.removeFromSuperview()
            }
            setUpControl()
        }
    }
    
    private func initialSetup() {
    }
    
    func setUpControl() {
        guard let control = control else {
            return
        }
        contentView.addSubview(control)
        control.edges --> contentView.edges
        
        setUpTapAndHoldGesture()
    }
    
    // MARK: - Drag & Drop
    
    func setUpTapAndHoldGesture() {
        guard let control = control else {
            return
        }
        
        let gesture = UILongPressGestureRecognizer(target: self, action: .longPressed)
        gesture.minimumPressDuration = 0.2
        control.addGestureRecognizer(gesture)
    }
    
    fileprivate var lastLocation: CGPoint?
    fileprivate var startFrame: CGRect?
    
    @objc func longPressed(gesture: UILongPressGestureRecognizer) {
        guard let control = control else {
            return
        }
        if gesture.state == .began || gesture.state == .ended || gesture.state == .cancelled {
            lastLocation = nil
        }
        if gesture.state == .ended {
            if didLongPressEndOutsideOfMenuBar() {
                notifyDelegateOfAddedComponent()
                animateControlPoppingIntoMenuBar()
            } else {
                animateControlReturningToMenuBar()
            }
            
            self.startFrame = nil
            
            return
        }
        
        let location = gesture.location(in: self)
        
        var difference = CGPoint.zero
        if let lastLocation = lastLocation {
            difference.x = location.x - lastLocation.x
            difference.y = location.y - lastLocation.y
        }
        lastLocation = location
        
        if gesture.state == .began {
            startFrame = control.frame
            control.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            return
        }
        
        let minimumChange: CGFloat = 0.2
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
    
    func animateControlReturningToMenuBar() {
        guard let startFrame = startFrame,
            let control = control else {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            control.transform = CGAffineTransform(scaleX: 1, y: 1)
            control.frame = startFrame
        })
    }
    
    func animateControlPoppingIntoMenuBar() {
        guard let startFrame = startFrame,
            let control = control else {
            return
        }
        control.frame = startFrame
        control.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: UIView.AnimationOptions.curveEaseOut, animations: {
            control.transform = CGAffineTransform(scaleX: 1, y: 1)
            control.frame = startFrame
        })
    }
    
    func didLongPressEndOutsideOfMenuBar() -> Bool {
        guard let collectionView = collectionView,
            let control = control else {
            return false
        }
        let localFrame = control.frame
        let externalFrame = contentView.convert(localFrame, to: collectionView)
        let collectionViewFrame = collectionView.bounds
        let intersection = collectionViewFrame.intersection(externalFrame)
        
        if intersection.isNull || intersection.height < 1 {
            return true
        }
        
        let yPercentageInsideOfMenuBar = (intersection.height / localFrame.height) * 100
        let percentageToAllowInside: CGFloat = 30
        if yPercentageInsideOfMenuBar < percentageToAllowInside {
            return true
        }
        
        return false
    }
    
    // MARK: - Call Delegate
    
    func notifyDelegateOfAddedComponent() {
        guard let control = control,
            let component = component else {
            return
        }
        delegate?.add(component: component,
                      atFrame: control.bounds,
                      fromView: control)
    }
    
}

// MARK: - Selector Extension

private extension Selector {
    static let longPressed = #selector(ControlBarItemCell.longPressed(gesture:))
}
