//
//  EditKitValueCell.swift
//  Slate
//
//  Created by John Coates on 8/22/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class EditKitValueCell: EditKitLinkCell {
    
    // MARK: - Configuration
    
    var value: String? {
        didSet {
            valueLabel.text = value
        }
    }
    
    var optimalValue: String? {
        didSet {
            optimalValueLabel.text = optimalValue
        }
    }
    
    var constrained: String? {
        didSet {
            constrainedLabel.text = constrained
        }
    }
    
    func updateLayout() {
        resetConstraints()
        
        if value != nil {
            contentView.ensureInHierarchy(view: valueLabel)
            setUpValueConstraints()
        } else {
            contentView.removeFromHiearchyAsNeeded(view: valueLabel)
        }
        
        let optimalValueLabels: [UIView] = [
            optimalValueLabel,
            optimalValueTitleLabel
        ]
        var optimalValueTopEdge: Anchor<YAxis> = titleLabel.bottom
        var optimalValueYPadding: CGFloat = 9
        
        if constrained != nil {
            contentView.ensureInHierarchy(view: constrainedLabel)
            setUpConstraintedLabelConstraints()
            optimalValueTopEdge = constrainedLabel.bottom
            optimalValueYPadding = 6
        } else {
            contentView.removeFromHiearchyAsNeeded(view: constrainedLabel)
        }
        
        if optimalValue != nil {
            contentView.ensureInHierarchy(views: optimalValueLabels)
            setUpOptimalValueLabelsConstraints(topEdge: optimalValueTopEdge,
                                               yPadding: optimalValueYPadding)
        } else {
            contentView.removeFromHiearchyAsNeeded(views: optimalValueLabels)
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    // MARK: - Setup
    
    override func initialSetup() {
        super.initialSetup()
        contentView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        contentView.translatesAutoresizingMaskIntoConstraints = true
        setUpValue()
        setUpOptimalValueLabels()
        setUpConstrained()
    }
    
    private let valueLabel = UILabel()
    
    private func setUpValue() {
        configure(titleLabel: valueLabel)
        contentView.addSubview(valueLabel)
    }
    
    private func setUpOptimalValueLabels() {
        setUpOptimalValueTitle()
        setUpOptimalValue()
    }
    
    private let optimalValueTitleLabel = UILabel()
    
    private func setUpOptimalValueTitle() {
        configure(optimalLabel: optimalValueTitleLabel)
        optimalValueTitleLabel.text = "Optimal Value"
    }
    
    private let optimalValueLabel = UILabel()
    
    private func setUpOptimalValue() {
        configure(optimalLabel: optimalValueLabel)
    }
    
    private func configure(optimalLabel: UILabel) {
        optimalLabel.font = UIFont.system(12, weight: .regular)
        optimalLabel.textColor = UIColor(red: 0.39, green: 1.00,
                                         blue: 0.70, alpha: 1.00)
        contentView.addSubview(optimalLabel)
    }
    
    private let constrainedLabel = UILabel()
    
    private func setUpConstrained() {
        configure(optimalLabel: constrainedLabel)
        constrainedLabel.textColor = UIColor(red: 0.70, green: 0.70,
                                            blue: 0.70, alpha: 1.00)
        
    }
    
    // MARK: - Constraints
    
    override func setUpTitleConstraints() {
        titleLabel.left --> contentView.leftMargin
        titleLabel.top --> contentView.topMargin
        contentView.bottomMargin -->+= titleLabel.bottom
    }

    private func setUpValueConstraints() {
        let constraints = captureConstraints {
            valueLabel.left.pin(to: contentView.centerX, add: -40)
            valueLabel.firstBaseline --> titleLabel.firstBaseline
            contentView.bottomMargin -->+= valueLabel.bottom
        }
        store(constraints: constraints)
    }
    
    private func setUpOptimalValueLabelsConstraints(topEdge: Anchor<YAxis>,
                                                    yPadding: CGFloat) {
        let constraints = captureConstraints {
            optimalValueTitleLabel.left --> titleLabel
            optimalValueTitleLabel.top.pin(to: topEdge, add: yPadding)
            
            optimalValueLabel.left --> valueLabel
            optimalValueLabel.firstBaseline --> optimalValueTitleLabel.firstBaseline
            contentView.bottomMargin -->+= optimalValueTitleLabel.bottom
            contentView.bottomMargin -->+= optimalValueLabel.bottom
        }
        store(constraints: constraints)
    }
    
    private func setUpConstraintedLabelConstraints() {
        let yPadding: CGFloat = 9
        
        let constraints = captureConstraints {
            constrainedLabel.left --> valueLabel
            constrainedLabel.top.pin(to: valueLabel.bottom,
                                     add: yPadding)
            contentView.bottomMargin -->+= constrainedLabel.bottom
        }
        store(constraints: constraints)
    }
    
    private var storedConstraints = [NSLayoutConstraint]()
    
    private func store(constraints: [NSLayoutConstraint]) {
        storedConstraints.append(contentsOf: constraints)
    }
    
    private func resetConstraints() {
        NSLayoutConstraint.deactivate(storedConstraints)
        storedConstraints = []
    }
    
}
