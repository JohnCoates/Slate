//
//  DebugWindow.swift
//  Slate
//
//  Created by John Coates on 12/28/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

final class DebugWindow: UIWindow {
    
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
        setUpTapGesture()
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: .activationTap)
    }()
    private func setUpTapGesture() {
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - User Interaction
    
    func activationTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: nil)
        
        let bounds = self.bounds
        var bottomRight = CGRect(x: 0, y: 0,
                                 width: 50, height: 50)
        bottomRight.origin.x = bounds.width - bottomRight.width
        bottomRight.origin.y = bounds.height - bottomRight.height
        guard bottomRight.contains(location) else {
            return
        }
        
        DebugBarController.sharedInstance.toggleActivation()
    }
}

// MARK: - Selector Extension

private extension Selector {
    static let activationTap = #selector(DebugWindow.activationTap)
}
