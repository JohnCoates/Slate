//
//  EditKitSliderCell
//  Created on 4/8/18.
//  Copyright © 2018 John Coates. All rights reserved.
//

import UIKit

class EditKitSliderCell: UITableViewCell {
    
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
        
        setUpTitle()
        setUpDetailLabel()
        setUpSlider()
        
        setNeedsUpdateConstraints()
    }
    
    let titleLabel = UILabel()
    
    func setUpTitle() {
        configure(titleLabel: titleLabel)
        contentView.addSubview(titleLabel)
        
        setUpTitleConstraints()
    }
    
    func setUpTitleConstraints() {
        titleLabel.top.pin(to: contentView, add: 10)
        titleLabel.left.pin(to: contentView.leftMargin)
    }
    
    private let detailLabel = UILabel()
    
    func setUpDetailLabel() {
        detailLabel.font = UIFont.system(17, weight: .regular)
        detailLabel.textColor = UIColor(red: 0.56, green: 0.56,
                                        blue: 0.58, alpha: 1.00)
        
        contentView.addSubview(detailLabel)
    }
    
    private func setUpDetailLabelConstraints() {
        detailLabel.baseline --> titleLabel
    }
    
    func configure(titleLabel: UILabel) {
        titleLabel.font = UIFont.system(17, weight: .regular)
        titleLabel.textColor = UIColor.white
    }
    
    private let slider = UISlider()
    
    private func setUpSlider() {
        slider.isContinuous = true
        slider.minimumValue = 1
        slider.maximumValue = 100
        
        contentView.addSubview(slider)
        setUpSliderConstraints()
    }
    
    private func setUpSliderConstraints() {
        slider.sizeToFit()
        
        slider.width.pin(to: contentView, times: 0.8)
        slider.centerX --> contentView
        slider.top.pin(to: contentView.top, add: 52)
//        slider.bottom.pin(atLeast: contentView.bottom, add: -8)
        contentView.bottom.pin(atLeast: slider.bottom, add: 8)
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
            

            detailLabel.right.pin(to: contentView.rightMargin)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        constructConstraints()
    }
    
}
