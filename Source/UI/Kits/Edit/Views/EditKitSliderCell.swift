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
    
    var minimum: Float {
        get {
            return slider.minimumValue
        }
        set {
            slider.minimumValue = newValue
        }
    }
    
    var maximum: Float {
        get {
            return slider.maximumValue
        }
        set {
            slider.maximumValue = newValue
        }
    }
    
    var value: Float {
        get {
            return slider.value
        }
        set {
            slider.value = newValue
        }
    }
    
    var continuousUpdates: Bool {
        get {
            return slider.isContinuous
        }
        set {
            slider.isContinuous = continuousUpdates
        }
    }
    
    var valueChanged: ((EditKitSliderCell, Float) -> Void)?
    
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
        slider.minimumTrackTintColor = UIColor(red: 0.00, green: 0.48, blue: 0.99, alpha: 1.00)
        slider.addTarget(self, action: #selector(valueChangedEvent),
                         for: .valueChanged)
        
        contentView.addSubview(slider)
        setUpSliderConstraints()
    }
    
    private func setUpSliderConstraints() {
        slider.height --> slider.intrinsicContentSize.height
        slider.width.pin(to: contentView, times: 0.8)
        slider.centerX --> contentView
        slider.top.pin(to: contentView.top, add: 52)
        contentView.bottom.pin(to: slider, add: 8, rank: .high)
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
    
    // MARK: - Reusing Cells
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueChanged = nil
    }
    
    // MARK: - Value Events
    
    @objc private func valueChangedEvent() {
        valueChanged?(self, slider.value)
    }
    
}
