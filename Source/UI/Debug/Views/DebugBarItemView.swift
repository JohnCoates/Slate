//
//  DebugBarItemView.swift
//  Slate
//
//  Created by John Coates on 12/29/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import UIKit

class DebugBarItemView: UIView {
    
    let item: DebugBarItem
    
    // MARK: - Init
    
    init(item: DebugBarItem) {
        self.item = item
        super.init(frame: CGRect.zero)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        fatalError("wrong intializer")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("wrong intializer")
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        setUpLabel()
        setUpTapGesture()
    }
    
    let label = UILabel()
    
    private func setUpLabel() {
        label.adjustsFontSizeToFitWidth = true
        label.text = item.title
        label.setContentCompressionResistancePriority(50, for: .horizontal)
        setContentCompressionResistancePriority(50, for: .horizontal)
        addSubview(label)
        
        label.left -->+= left
        label.right -->-= right
        label.top -->+= top
        label.bottom -->-= bottom
        label.centerXY --> centerXY
    }
    
    // MARK: - Setup
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: .tapped)
    }()
    
    private func setUpTapGesture() {
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - User Interaction
    
    func tapped(gesture: UITapGestureRecognizer) {
        guard let tapClosure = item.tapClosure else {
            return
        }
        tapClosure()
    }
    
    // MARK: - Visualize Touch Response
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.8
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        alpha = 1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        alpha = 1
    }
    
    // MARK: - Layout
    
    override var intrinsicContentSize: CGSize {
        return label.intrinsicContentSize
    }
}

// MARK: - Selector Extension

private extension Selector {
    static let tapped = #selector(DebugBarItemView.tapped)
}
