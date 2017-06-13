//
//  Button.swift
//  Slate
//
//  Created by John Coates on 9/26/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import UIKit

class Button: UIView, EditOpacity {
    
    // MARK: - Configuration
    
    var tapCallback: (() -> Void)?
    
    /// setCallback(self, class.method)
    func setTappedCallback<T: AnyObject>(instance: T,
                                         method: @escaping (T) -> () -> Void) {
        tapCallback = {
            [unowned instance] in
            method(instance)()
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
    
    /// When overriding this, make sure to call super!
    func initialSetup() {
        self.accessibilityIdentifier = "Button"
        backgroundColor = .clear
        setUpTapGesture()
        setUpContentView()
    }
    
    private var tapGesture: UITapGestureRecognizer!
    
    private func setUpTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: .tapped)
        addGestureRecognizer(tapGesture)
    }
    
    // Content view means we can have 0 opacity but still be tappable
    var contentView = RoundableView()
    
    private func setUpContentView() {
        contentView.backgroundColor = .clear
        contentView.accessibilityIdentifier = "Button:ContentView"
        addSubview(contentView)
        
        contentView.edges --> edges
    }
    
    // MARK: - Visualize Touch Response
    
    var originalAlpha: CGFloat?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if originalAlpha == nil {
            originalAlpha = alpha
        }
        alpha = 0.8
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        restoreAlpha()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        restoreAlpha()
    }
    
    fileprivate func restoreAlpha() {
        guard let originalAlpha = originalAlpha else {
            return
        }
        
        alpha = originalAlpha
        self.originalAlpha = nil
    }
    
    // MARK: - Tappable While Invisible
    
    static let defaultOpacity: Float = 1
    
    var opacity: Float {
        set {
            contentView.alpha = CGFloat(newValue)
        }
        get {
            return Float(contentView.alpha)
        }
    }
    
    // MARK: - Roundable
    
    var rounding: Float {
        get {
            return contentView.rounding
        }
        set {
            contentView.rounding = newValue
        }
    }
    
    // MARK: - Tap Area
    
    var tapAreaPixels: CGFloat? {
        didSet {
            if tapAreaPixels != nil {
                updateTapAreaPixelConstraints()
            }
        }
    }
    var tapAreaPercentage: Float? {
        didSet {
            if tapAreaPercentage != nil {
                ensureNoViewSizeConstraints()
                updateTapAreaPercentageConstraints()
            }
        }
    }
    
    private func ensureNoViewSizeConstraints() {
        let errorMessage = "Error: Used sizing constraint on Button instead of contentView! " +
        "Add constraint to contentView to be compatible with tap areas"
        
        if constraintsWithAttribute(.width) != nil ||
            constraintsWithAttribute(.height) != nil {
            fatalError(errorMessage)
        }
    }
    
    private func resetConstraintsForTapArea() {
        var remove = [NSLayoutConstraint]()
        let attributes: [NSLayoutAttribute] = [.top, .left, .right, .bottom, .centerY, .centerX]
        for attribute in attributes {
            if let constraints = contentView.constraintsBetween(view: contentView, view2: self,
                                                                viewAttribute: attribute) {
                remove += constraints
            }
        }
        
        NSLayoutConstraint.deactivate(remove)
    }
    
    private func updateTapAreaPixelConstraints() {
        guard let tapAreaPixels = tapAreaPixels else {
            fatalError("Tap area pixels missing!")
        }
        ensureNoViewSizeConstraints()
        resetConstraintsForTapArea()
        
        width.pin(to: contentView.width, add: tapAreaPixels)
        height.pin(to: contentView.height, add: tapAreaPixels)
        contentView.centerXY --> centerXY
    }
    
    private func updateTapAreaPercentageConstraints() {
        guard let tapAreaPercentage = tapAreaPercentage else {
            fatalError("Tap area percentage missing!")
        }
        ensureNoViewSizeConstraints()
        resetConstraintsForTapArea()
        
        width.pin(to: contentView.width, times: CGFloat(tapAreaPercentage))
        height.pin(to: contentView.height, times: CGFloat(tapAreaPercentage))
        contentView.centerXY --> centerXY
    }
    
    // MARK: - User Interaction
    
    func tapped(gesture: UITapGestureRecognizer) {
        guard let tapCallback = tapCallback else {
            return
        }
        tapCallback()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
    }
    
}

// MARK: - Selector Extension

private extension Selector {
    static let tapped = #selector(Button.tapped)
}
