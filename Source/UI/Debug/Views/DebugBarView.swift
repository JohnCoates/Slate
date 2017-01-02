//
//  DebugBarView.swift
//  Slate
//
//  Created by John Coates on 12/29/16.
//  Copyright © 2016 John Coates. All rights reserved.
//

import Foundation
import Cartography

final class DebugBarView: UIView {
    
    var items: [DebugBarItem] = [] {
        didSet {
            refreshStackItems()
        }
    }
    
    var itemViews: [UIView] = []
    
    // MARK: - Init
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        setUpStackView()
        backgroundColor = UIColor.white
    }
    
    let stackView = UIStackView()
    private func setUpStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        stackView.alignment = .center
        
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10,
                                               bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        addSubview(stackView)
        
        constrain(stackView) {
            let superview = $0.superview!
            $0.left == superview.left
            $0.right == superview.right
            $0.top == superview.top
            $0.bottom == superview.bottom
        }
    }
    
    // MARK: - Stack View
    
    func refreshStackItems() {
        itemViews = items.map({DebugBarItemView(item:$0)})
        
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for view in itemViews {
            stackView.addArrangedSubview(view)
        }
    }

}
