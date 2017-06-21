//
//  LayoutPreviewCell.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

private typealias LocalClass = LayoutPreviewCell

protocol LayoutPreviewCellDelegate: class {
    func promptUserToSelectPreviewDevice()
}

enum DeviceType: String {
    case seven = "iPhone 7"
    case sevenPlus = "iPhone 7 Plus"
    case se = "iPhone SE"
    
    var pointsSize: Size {
        switch self {
        case .seven:
            return Size(width: 375, height: 667)
        case .sevenPlus:
            return Size(width: 414, height: 736)
        case .se:
            return Size(width: 320, height: 568)
        }
    }
    
    var pixels: Size {
        switch self {
        case .seven, .se:
            return pointsSize * 2
        case .sevenPlus:
            return pointsSize * 3
        }
    }
}

final class LayoutPreviewCell: UITableViewCell {

    weak var delegate: LayoutPreviewCellDelegate?
    
    var device: DeviceType {
        didSet {
            refreshDevice()
        }
    }
    
    // MARK: - Init
    
    let kit: Kit
    
    init(kit: Kit, delegate: LayoutPreviewCellDelegate) {
        self.kit = kit
        self.delegate = delegate
        self.device = DeviceType.se
        
        super.init(style: .default, reuseIdentifier: nil)
        initialSetup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        Critical.methodNotDefined()
    }
    
    required init?(coder aDecoder: NSCoder) {
        Critical.methodNotDefined()
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        setUpTitleButton()
        setUpPreview()
        
        selectionStyle = .none
        backgroundColor = Theme.Settings.background
        contentView.bottom.pin(to: preview.bottom, add: 10)
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    let titleButton = Button()
    
    func setUpTitleButton() {
        contentView.addSubview(titleButton)
        
        setUpTitleLabel()
        setUpTitleInteractivityIndicator()
        
        titleButton.tapAreaPercentage = 1.2
        titleButton.setTappedCallback(instance: self, method: Method.titleTapped)
        
        titleButton.contentView.left --> titleLabel.left
        titleButton.contentView.top --> titleLabel.top
        titleButton.contentView.right --> titleInteractivityIndicator.right
        titleButton.contentView.bottom --> titleLabel.bottom
    }
    
    let titleLabel = UILabel()
    
    func setUpTitleLabel() {
        titleLabel.text = device.rawValue
        titleLabel.font = UIFont.system(17, weight: .medium)
        titleLabel.textColor = Theme.Kits.text
        titleButton.contentView.addSubview(titleLabel)
        
        titleLabel.centerX --> contentView.centerX
        titleLabel.top.pin(to: contentView.top, add: 2)
        
        setUpTitleInteractivityIndicator()
    }
    
    let titleInteractivityIndicator = CanvasIconView(asset: CommonIcon.interactivityIndicator)
    
    func setUpTitleInteractivityIndicator() {
        titleButton.contentView.addSubview(titleInteractivityIndicator)
        
        titleInteractivityIndicator.left.pin(to: titleLabel.right, add: 4)
        titleInteractivityIndicator.centerY.pin(to: titleLabel.centerY, add: 1)
        titleInteractivityIndicator.width --> 11.5
        titleInteractivityIndicator.height --> 3.5
    }
    
    lazy var capturePreviewController: LayoutPreviewCaptureViewController = {
        return LayoutPreviewCaptureViewController(kit: self.kit)
    }()
    lazy var preview: UIView = self.capturePreviewController.view
    
    var previewSizeConstraints = [NSLayoutConstraint]()
    
    func setUpPreview() {
        contentView.addSubview(preview)
        
        preview.isUserInteractionEnabled = false
        
        refreshPreviewSize()
        
        preview.top.pin(to: titleLabel.bottom, add: 13)
        preview.centerX --> contentView.centerX
    }
    
    func refreshPreviewSize() {
        if previewSizeConstraints.count > 0 {
            NSLayoutConstraint.deactivate(previewSizeConstraints)
            previewSizeConstraints.removeAll()
        }
        let widthConstraint = preview.width.pin(to: contentView.width,
                                                times: 0.6)
        let heightConstraint = preview.height.pin(to: preview.width,
                                                  times: screenHeightToWidthRatio)
        previewSizeConstraints.append(widthConstraint)
        previewSizeConstraints.append(heightConstraint)
    }
    
    var screenHeightToWidthRatio: CGFloat {
        let size = device.pointsSize
        return size.cgHeight / size.cgWidth
    }    
    
    // MARK: - Device Changes
    
    func refreshDevice() {
        titleLabel.text = device.rawValue
        refreshPreviewSize()
    }
    
    // MARK: - Title Tapped

    func titleTapped() {
        delegate?.promptUserToSelectPreviewDevice()
    }
    
}

// MARK: - Callbacks

fileprivate struct Method {
    static let titleTapped = LocalClass.titleTapped
    
}
