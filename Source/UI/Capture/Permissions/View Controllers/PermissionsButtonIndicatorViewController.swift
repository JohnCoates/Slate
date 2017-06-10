//
//  PermissionsButtonIndicatorViewController.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class PermissionsButtonIndicatorViewController: UIViewController {
    
    // MARK: - Init
    
    let okayButtonFrame: CGRect
    init(buttonFrame: CGRect) {
        okayButtonFrame = buttonFrame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class is not NSCoder compliant")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0
        self.view.backgroundColor = UIColor.white
        setUpViews()
    }
    
    var okayButtonPlaceholder = UIView(frame: .zero)
    
    let indicator = CanvasIconView(icon: ButtonIndicatorIcon())
    var indicatorTopConstraint: NSLayoutConstraint?
    let indicatorDistance: CGFloat = 12
    
    func setUpViews() {
        okayButtonPlaceholder.frame = okayButtonFrame
        okayButtonPlaceholder.isHidden = true
        view.addSubview(okayButtonPlaceholder)
        view.addSubview(indicator)
        
        let heightRatio = indicator.icon.height / indicator.icon.width
        
        indicator.centerX --> okayButtonPlaceholder.centerX
        indicatorTopConstraint = indicator.top.pin(to: okayButtonPlaceholder.bottom,
                                                   add: indicatorDistance)
        indicator.width --> 20
        indicator.height.pin(to: indicator.width, times: heightRatio)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { 
            self.view.alpha = 1
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate = true
        startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animate = false
    }
    
    // MARK: - Animation
    
    var animate: Bool = false
    
    func startAnimating() {
        self.animatePullback(delay: 1)
    }
    
    func animatePullback(delay: TimeInterval) {
        guard animate else {
            return
        }
        guard let indicatorTopConstraint = indicatorTopConstraint else {
            fatalError("Missing indicator top constraint!")
        }
        
        view.layoutIfNeeded()
        let pullDistance: CGFloat = 12
        let distance: CGFloat = indicatorDistance + pullDistance
        UIView.animate(withDuration: 0.2, delay: delay, options: [.curveEaseInOut], animations: {
            indicatorTopConstraint.constant = distance
            self.view.layoutIfNeeded()
        }) { completed in
            self.animateBounce()
        }
    }
    
    func animateBounce() {
        guard animate else {
            return
        }
        guard let indicatorTopConstraint = indicatorTopConstraint else {
            fatalError("Missing indicator top constraint!")
        }
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.25,
                       usingSpringWithDamping: 0.18,
                       initialSpringVelocity: 4,
                       options: .beginFromCurrentState, animations: {
            indicatorTopConstraint.constant = self.indicatorDistance
            self.view.layoutIfNeeded()
        }) { completed in
            self.animatePullback(delay: 1)
        }
    }
    
}
