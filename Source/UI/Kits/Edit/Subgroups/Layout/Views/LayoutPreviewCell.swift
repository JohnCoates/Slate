//
//  LayoutPreviewCell.swift
//  Slate
//
//  Created by John Coates on 6/19/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

final class LayoutPreviewCell: UITableViewCell {

    // MARK: - Init
    
    let kit: Kit
    
    init(kit: Kit) {
        self.kit = kit
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
        setUpTitleLabel()
        setUpPreview()
        
        selectionStyle = .none
        backgroundColor = Theme.Settings.background
        contentView.bottom.pin(to: preview.bottom, add: 10)
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    let titleLabel = UILabel()
    
    func setUpTitleLabel() {
        titleLabel.text = "iPhone 5s Preview"
        titleLabel.font = UIFont.system(17, weight: .medium)
        titleLabel.textColor = Theme.Kits.text
        contentView.addSubview(titleLabel)
        
        titleLabel.centerX --> contentView.centerX
        titleLabel.top.pin(to: contentView.top, add: 2)
    }
    
    lazy var capturePreviewController: LayoutPreviewCaptureViewController = {
        return LayoutPreviewCaptureViewController(kit: self.kit)
    }()
    lazy var preview: UIView = self.capturePreviewController.view
    
    func setUpPreview() {
        contentView.addSubview(preview)
        
        preview.isUserInteractionEnabled = false
        preview.width.pin(to: contentView.width, times: 0.6)
        preview.height.pin(to: preview.width, times: screenHeightToWidthRatio)
        
        preview.top.pin(to: titleLabel.bottom, add: 13)
        preview.centerX --> contentView.centerX
    }
    
    var screenHeightToWidthRatio: CGFloat {
        let screen = UIScreen.main
        let size = screen.nativeBounds.size
        return size.height / size.width
    }

}
