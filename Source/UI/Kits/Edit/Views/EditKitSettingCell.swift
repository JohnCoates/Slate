//
//  EditKitSettingCell.swift
//  Slate
//
//  Created by John Coates on 9/6/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class EditKitSettingCell: UITableViewCell {
    
    // MARK: - Configuration
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            setNeedsUpdateConstraints()
        }
    }
    
    var detail: String? {
        didSet {
            detailLabel.text = detail
            setNeedsUpdateConstraints()
        }
    }
    
    var showDisclosure = true {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    
    var icon: ImageAsset? {
        didSet {
            if let icon = icon {
                iconView.icon = VectorImageCanvasIcon(asset: icon)
            }
            setNeedsUpdateConstraints()
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func initialSetup() {
        selectionStyle = .none
        backgroundColor = Theme.Kits.cellBackground
        
        contentView.height.pin(atLeast: 40, rank: .high)
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        setUpIconView()
        setUpTitle()
        setUpDisclosureIndicator()
        setUpDetailLabel()
        
        setNeedsUpdateConstraints()
    }
    
    let iconView = CanvasIconButton()
    
    private func setUpIconView() {
        contentView.addSubview(iconView)
        
        iconView.width --> 20
        iconView.height --> iconView.width
        iconView.left.pin(to: left, add: 5)
        iconView.centerY --> contentView.centerY
    }
    
    let titleLabel = UILabel()
    
    func setUpTitle() {
        configure(titleLabel: titleLabel)
        contentView.addSubview(titleLabel)
        
        setUpTitleConstraints()
    }
    
    func setUpTitleConstraints() {
        titleLabel.centerY --> iconView.centerY
        titleLabel.left.pin(to: contentView.leftMargin)
    }
    
    private var detailLabel = UILabel()
    
    func setUpDetailLabel() {
        detailLabel.font = UIFont.system(17, weight: .regular)
        detailLabel.textColor = UIColor(red: 0.56, green: 0.56,
                                        blue: 0.58, alpha: 1.00)
        
        contentView.addSubview(detailLabel)
    }
    
    private func setUpDetailLabelConstraints() {
        detailLabel.centerY --> contentView
    }
    
    func configure(titleLabel: UILabel) {
        titleLabel.font = UIFont.system(17, weight: .regular)
        titleLabel.textColor = UIColor.white
    }
    
    let disclosureIndicator = CanvasIconView(asset: KitImage.disclosureIndicator)
    
    private func setUpDisclosureIndicator() {
        contentView.addSubview(disclosureIndicator)
        disclosureIndicator.color = UIColor(red: 0.78, green: 0.78,
                                            blue: 0.80, alpha: 1.00)
    }
    
    private func setUpDisclosureIndicatorConstraints() {
        disclosureIndicator.width --> 8
        disclosureIndicator.height --> 13
        disclosureIndicator.centerY --> contentView
        disclosureIndicator.right.pin(to: contentView.rightMargin)
    }
    
    // MARK: - Constraints
    
    var dynamicConstraints: [NSLayoutConstraint]?
    
    private func constructConstraints() {
        if let dynamicConstraints = dynamicConstraints {
            NSLayoutConstraint.deactivate(dynamicConstraints)
            self.dynamicConstraints = nil
        }
        
        dynamicConstraints = captureConstraints {
            setUpDetailLabelConstraints()
            
            if showDisclosure {
                setUpDisclosureIndicatorConstraints()
                detailLabel.right.pin(to: disclosureIndicator.left,
                                      add: -9)
            } else {
                detailLabel.right.pin(to: contentView.rightMargin)
            }
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        constructConstraints()
    }
    
}
