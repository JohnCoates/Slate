//
//  EditKitHeaderView.swift
//  Slate
//
//  Created by John Coates on 6/15/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

final class EditKitHeaderView: UIView {

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
        // call other setup methods that init views
        backgroundColor = Theme.Kits.background
        
        height -->+= 86
        
        setUpIconView()
        setUpTextStack()
    }
    
    let iconView = RoundableView()
    
    private func setUpIconView() {
        iconView.rounding = Theme.Kits.iconRounding
        iconView.backgroundColor = UIColor(red: 0.11, green: 0.51, blue: 1.00, alpha: 1.00)
        addSubview(iconView)
        
        iconView.left.pin(to: left, add: 7)
        iconView.centerY --> centerY
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
            
            addSubview(textStack)
            textStack.left.pin(to: iconView.right, add: 12)
            textStack.centerY --> centerY
            
            setUpTitleLabel()
            setUpAuthorLabel()
    }
    
    let titleLabel = UILabel()
    
    private func setUpTitleLabel() {
        titleLabel.text = "Portraits"
        titleLabel.textColor = Theme.Kits.text
        titleLabel.font = Theme.Kits.cellTitle
    }
    
    let authorLabel = UILabel()
    
    private func setUpAuthorLabel() {
        authorLabel.text = "John Coates @JohnCoates"
        authorLabel.textColor = Theme.Kits.text
        authorLabel.font = Theme.Kits.cellSubtitle
    }

}
