//
//  PermissionsEducationViewController.swift
//  Slate
//
//  Created by John Coates on 5/17/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import AVFoundation

private typealias LocalClass = PermissionsEducationViewController
class PermissionsEducationViewController: UIViewController {
    
    weak var delegate: PermissionsManagerDelegate?
    init(delegate: PermissionsManagerDelegate? = nil) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Doesn't implement NSCoder")
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        configureEducation()
        setUpViews()
    }
    
    // MARK: - Setup
    
    struct DialogButton {
        var text: String?
        var textColor: UIColor?
        var backgroundColor: UIColor?
        var tappedHandler: (() -> Void)?
    }
    
    var buttons = [DialogButton]()
    
    /// Used by subclasses
    func configureEducation() {
        Critical.subclassMustImplementMethod()
    }
    
    func setUpViews() {
        setUpDialog()
        setUpImageView()
        setUpExplanation()
        setUpPreviewView()
        setUpButtons()
    }
    
    let dialog = RoundableView()
    func setUpDialog() {
        dialog.layoutMargins = UIEdgeInsets(top: 23, left: 0, bottom: 19, right: 0)
        dialog.rounding = 0.05
        dialog.backgroundColor = UIColor.white
        view.addSubview(dialog)
        
        dialog.centerXY --> view.centerXY
        dialog.width --> 250
        dialog.height -->+= 100
    }
    
    var educationImage: CanvasIcon?
    var educationImageSize: CGSize?
    var imageView: CanvasIconView?
    
    func setUpImageView() {
        guard let educationImage = educationImage else {
            fatalError("Missing education image")
        }
        guard let educationImageSize = educationImageSize else {
            fatalError("Missing education image size")
        }
        
        let imageView = CanvasIconView(icon: educationImage)
        self.imageView = imageView
        dialog.addSubview(imageView)
        imageView.top.pin(to: dialog.top, add: 23)
        imageView.centerX --> dialog.centerX
        imageView.width --> educationImageSize.width
        imageView.height --> educationImageSize.height
    }
    
    let explanationLabel = UILabel()
    var explanation: String?
    func setUpExplanation() {
        guard let imageView = imageView else {
            fatalError("Missing image view, can't lay out explanation")
        }
        explanationLabel.text = explanation
        explanationLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        explanationLabel.textColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.00)
        explanationLabel.adjustsFontSizeToFitWidth = false
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .center
        dialog.addSubview(explanationLabel)
        
        explanationLabel.width.pin(to: dialog.width, times: 0.9)
        explanationLabel.centerX --> dialog.centerX
        explanationLabel.top.pin(to: imageView.bottom, add: 24)
    }
    
    var previewView: UIView?
    func setUpPreviewView() {
    }
    
    func privacyCellPreview(withText text: String) -> UIView {
        let separatorHeight = 1.pixelsAsPoints
        var cellHeight = UITableViewCell(style: .default, reuseIdentifier: nil).frame.height
        cellHeight += separatorHeight * 2
        
        let label = UILabel(frame: .zero)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.textColor = .black
        
        let toggle = UISwitch(frame: .zero)
        toggle.isUserInteractionEnabled = false
        toggle.isOn = true
        
        let preview = UIView(frame: .zero)
        preview.backgroundColor = UIColor.white
        
        dialog.addSubview(preview)
        
        preview.height --> cellHeight
        preview.left --> dialog.left
        preview.right --> dialog.right
        preview.top.pin(to: explanationLabel.bottom, add: 16)

        addCellSeparator(kind: .top, toCellView: preview)
        addCellSeparator(kind: .bottom, toCellView: preview)
        
        preview.add(subviews: [label, toggle])
        
        label.centerY --> preview.centerY
        toggle.centerY --> preview.centerY
        label.left.pin(to: preview.left, add: 15)
        toggle.right.pin(to: preview.right, add: -15)
        
        return preview
    }
    
    enum CellSeparatorKind {
        case top
        case bottom
    }
    
    func addCellSeparator(kind: CellSeparatorKind, toCellView cellView: UIView) {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.00)
        cellView.addSubview(separator)
        
        separator.height --> 1.pixelsAsPoints
        separator.left --> cellView.left
        separator.right --> cellView.right
        switch kind {
        case .top:
            separator.top --> cellView.top
        case .bottom:
            separator.bottom --> cellView.bottom
        }
    }
    
    func setUpButtons() {
        var lastButton: Button?
        
        for dialogButton in buttons {
            let button = generateView(forButton: dialogButton)
            let aboveView: UIView
            let distanceFromAboveView: CGFloat
            if let lastButtonReal = lastButton {
                aboveView = lastButtonReal
                distanceFromAboveView = 13
            } else if let previewView = previewView {
                aboveView = previewView
                distanceFromAboveView = 19
            } else {
                aboveView = explanationLabel
                distanceFromAboveView = 16
            }

            button.top.pin(to: aboveView.bottom, add: distanceFromAboveView)
            lastButton = button
        }
        guard let lastButtonReal = lastButton, let superview = lastButtonReal.superview else {
            fatalError("Can't finish setting up buttons")
        }
        
        superview.bottomMargin -->+= lastButtonReal.bottom
    }
    
    func generateView(forButton dialogButton: DialogButton) -> Button {
        let button = Button()
        button.backgroundColor = dialogButton.backgroundColor
        button.rounding = 0.1
        button.tapCallback = dialogButton.tappedHandler
        
        let label = UILabel()
        label.text = dialogButton.text
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.textColor = dialogButton.textColor
        button.addSubview(label)
        
        label.centerXY --> button.centerXY
        
        dialog.addSubview(button)
        
        button.height --> 36
        button.width.pin(to: dialog.width, times: 0.88)
        button.centerX --> dialog.centerX
        
        return button
    }
}
