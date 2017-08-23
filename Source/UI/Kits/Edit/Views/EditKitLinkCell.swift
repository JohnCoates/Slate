//
//  EditKitLinkCell.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

class EditKitLinkCell: UITableViewCell {
    
    // MARK: - Configuration
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var icon: ImageAsset? {
        didSet {
            if let icon = icon {
                iconView.icon = VectorImageCanvasIcon(asset: icon)
            }
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
        backgroundColor = Theme.Kits.background
        
        contentView.height.pin(atLeast: 40, rank: .high)
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        setUpIconView()
        setUpTitle()
        setUpDisclosureIndicator()
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
        titleLabel.left.pin(to: iconView.right, add: 11)
    }
    
    func configure(titleLabel: UILabel) {
        titleLabel.font = UIFont.system(17, weight: .regular)
        titleLabel.textColor = UIColor.white
    }
    
    let disclosureInidicator = CanvasIconView(asset: KitImage.disclosureIndicator)
    
    private func setUpDisclosureIndicator() {
        contentView.addSubview(disclosureInidicator)
        
        disclosureInidicator.width --> 8
        disclosureInidicator.height --> 13
        disclosureInidicator.centerY --> contentView.centerY
        disclosureInidicator.right.pin(to: contentView.right, add: -12)
    }
    
}
