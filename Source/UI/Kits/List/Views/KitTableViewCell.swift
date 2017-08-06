//
//  KitTableViewCell.swift
//  Slate
//
//  Created by John Coates on 6/5/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

private typealias LocalClass = KitTableViewCell
final class KitTableViewCell: UITableViewCell {
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        selectionStyle = .none
        
        // call other setup methods that init views
        contentView.backgroundColor = Theme.Kits.background
        
        contentView.height.pin(to: 86, rank: .high)
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        setUpIconView()
        setUpTextStack()
        setUpSettingsButton()
    }
    
    let iconView = RoundableView()
    
    private func setUpIconView() {
        iconView.rounding = Theme.Kits.iconRounding
        iconView.backgroundColor = UIColor(red: 0.11, green: 0.51, blue: 1.00, alpha: 1.00)
        contentView.addSubview(iconView)
        
        iconView.left.pin(to: contentView.left, add: 7)
        iconView.centerY --> contentView.centerY
        iconView.width --> 50
        iconView.height --> iconView.width
    }
    
    lazy var textStack: UIStackView = {
        return UIStackView(arrangedSubviews: [self.titleLabel, self.authorLabel])
    }()
    
    func setUpTextStack() {
        textStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textStack.isLayoutMarginsRelativeArrangement = true
        textStack.axis = .vertical
        textStack.distribution = .fill
        textStack.spacing = 6
        textStack.alignment = .leading
        
        contentView.addSubview(textStack)
        textStack.left.pin(to: iconView.right, add: 12)
        textStack.centerY --> contentView.centerY
        
        setUpTitleLabel()
        setUpAuthorLabel()
        setUpDateLabel()
    }
    
    let titleLabel = UILabel()
    
    private func setUpTitleLabel() {
        titleLabel.text = "Portraits"
        titleLabel.textColor = Theme.Kits.text
        titleLabel.font = Theme.Kits.cellTitle
    }
    
    let authorLabel = UILabel()
    
    private func setUpAuthorLabel() {
        authorLabel.text = "@JohnCoates"
        authorLabel.textColor = Theme.Kits.text
        authorLabel.font = Theme.Kits.cellSubtitle
    }
    
    let dateLabel = UILabel()
    
    private func setUpDateLabel() {
        dateLabel.text = "June 6, 2017"
        dateLabel.textColor = Theme.Kits.dateText
        dateLabel.font = Theme.Kits.cellSubtitle
        
        contentView.addSubview(dateLabel)
        
        dateLabel.left.pin(to: authorLabel.right, add: 7)
        dateLabel.baseline --> authorLabel.baseline
    }
    
    let settingsButton = CanvasIconButton(asset: KitImage.settings)
    
    private func setUpSettingsButton() {
        contentView.addSubview(settingsButton)
        let buttonView = settingsButton.contentView
        buttonView.right.pin(to: contentView.right, add: -21)
        buttonView.centerY --> contentView.centerY
        buttonView.width --> 22
        buttonView.height --> buttonView.width
        settingsButton.tapAreaPercentage = 2
        
        settingsButton.setTappedCallback(instance: self, method: Method.tapped)
    }
    
    fileprivate func tapped() {
        print("settings tapped")
    }
    
}

// MARK: - Callbacks

private struct Method {
    static let tapped = LocalClass.tapped
}
