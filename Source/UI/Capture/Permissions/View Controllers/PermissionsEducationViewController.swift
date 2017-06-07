//
//  PermissionsEducationViewController.swift
//  Slate
//
//  Created by John Coates on 5/17/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography
import AVFoundation

fileprivate typealias LocalClass = PermissionsEducationViewController
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
        fatalError("configureEducation not implemented")
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
        
        dialog.centerXY2 --> view.centerXY2
        dialog.width2 --> 250
        dialog.height2 -->+= 100
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
        imageView.centerX2 --> dialog.centerX2
        imageView.width2 --> educationImageSize.width
        imageView.height2 --> educationImageSize.height
        
//        constrain(imageView) {
//            let superview = $0.superview!
//            $0.top == superview.top + 23
//            $0.centerX == superview.centerX
//            $0.width == educationImageSize.width
//            $0.height == educationImageSize.height
//        }
    }
    
    let explanationLabel = UILabel()
    var explanation: String?
    func setUpExplanation() {
        guard let imageView = imageView else {
            fatalError("Missing image view, can't lay out explanation")
        }
        explanationLabel.text = explanation
        explanationLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        explanationLabel.textColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.00)
        explanationLabel.adjustsFontSizeToFitWidth = false
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .center
        dialog.addSubview(explanationLabel)
        
        explanationLabel.width2.pin(to: dialog.width2, times: 0.9)
        explanationLabel.centerX2 --> dialog.centerX2
        explanationLabel.top2.pin(to: imageView.bottom2, add: 24)
        
//        constrain(explanationLabel) {
//            let superview = $0.superview!
//            $0.width == superview.width * 0.9
//            $0.centerX == superview.centerX
//        }
        
//        constrain(explanationLabel, imageView) { explanationLabel, imageView in
//            explanationLabel.top == imageView.bottom + 24
//        }
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
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
        label.textColor = .black
        
        let toggle = UISwitch(frame: .zero)
        toggle.isUserInteractionEnabled = false
        toggle.isOn = true
        
        let preview = UIView(frame: .zero)
        preview.backgroundColor = UIColor.white
        
        dialog.addSubview(preview)
        
        preview.height2 --> cellHeight
        preview.left2 --> dialog.left2
        preview.right2 --> dialog.right2
        preview.top2.pin(to: explanationLabel.bottom2, add: 16)

        addCellSeparator(kind: .top, toCellView: preview)
        addCellSeparator(kind: .bottom, toCellView: preview)
        
        preview.add(subviews: [label, toggle])
        
        label.centerY2 --> preview.centerY2
        toggle.centerY2 --> preview.centerY2
        label.left2.pin(to: preview.left2, add: 15)
        toggle.right2.pin(to: preview.right2, add: -15)
        
        return preview
    }
    
    enum CellSeparatorKind {
        case top
        case bottom
    }
    
    func addCellSeparator(kind: CellSeparatorKind, toCellView cellView: UIView) {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.00)
        cellView.addSubview(separator)
        
        separator.height2 --> 1.pixelsAsPoints
        separator.left2 --> cellView.left2
        separator.right2 --> cellView.right2
        switch kind {
        case .top:
            separator.top2 --> cellView.top2
        case .bottom:
            separator.bottom2 --> cellView.bottom2
        }
        
//        constrain(separator) {
//            let superview = $0.superview!
//            $0.height == 1.pixelsAsPoints
//            $0.left == superview.left
//            $0.right == superview.right
//            switch kind {
//            case .top:
//                $0.top == superview.top
//            case .bottom:
//                $0.bottom == superview.bottom
//            }
//        }
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
        
        superview.bottomMargin -->+= lastButtonReal.bottom2
        
//        constrain(lastButtonReal) {
//            let superview = $0.superview!
//            superview.bottomMargin >= $0.bottom
//        }
    }
    
    func generateView(forButton dialogButton: DialogButton) -> Button {
        let button = Button()
        button.backgroundColor = dialogButton.backgroundColor
        button.rounding = 0.1
        button.tapCallback = dialogButton.tappedHandler
        
        let label = UILabel()
        label.text = dialogButton.text
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        label.textColor = dialogButton.textColor
        button.addSubview(label)
        
        constrain(label) {
            let superview = $0.superview!
            $0.center == superview.center
        }
        
        dialog.addSubview(button)
        
        constrain(button) {
            let superview = $0.superview!
            $0.height == 36
            $0.width == superview.width * 0.88
            $0.centerX == superview.centerX
        }
        
        return button
    }
    
    // MARK: - Alert Proxy
    
    let proxyAlertOkayText = "OK"
    var proxyWindow: UIWindow?
    
    typealias ButtonFrameCompletionBlock = (_ buttonFrame: CGRect?) -> Void
    
    func retrieveButtonFrameFromAlertProxy(completion: @escaping ButtonFrameCompletionBlock) {
        let presentingController = UIViewController()
        proxyWindow = createProxyWindow(withViewController: presentingController)
        
        let alertController = proxyAlertController()
        
        presentingController.present(alertController, animated: false, completion: {
            guard let confirmationButton = self.findConfirmationButton(inAlertController: alertController) else {
                self.tearDownAlertProxy()
                completion(nil)
                return
            }
            let buttonFrame = confirmationButton.convert(confirmationButton.frame, to: self.view)
            presentingController.dismiss(animated: false, completion: {
                self.tearDownAlertProxy()
                completion(buttonFrame)
            })
        })
    }
    
    func showOkayButtonIndicator(withOkayButtonFrame buttonFrame: CGRect, after: @escaping () -> Void) {
        let indicator = PermissionsButtonIndicatorViewController(buttonFrame: buttonFrame)
        present(indicator, animated: false, completion: {
            after()
        })
    }
    
    func createProxyWindow(withViewController viewController: UIViewController) -> UIWindow {
        let window = UIWindow()
        window.rootViewController = viewController
        window.isHidden = false
        window.windowLevel = UIWindowLevelNormal - 1
        return window
    }
    
    func tearDownAlertProxy() {
        proxyWindow?.isHidden = true
        proxyWindow = nil
    }
    
    var appName: String {
        if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return appName
        }
        
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            fatalError("Missing app name in Info.plist!")
        }
        
        return appName
    }
    
    func proxyAlertController() -> UIAlertController {
        let controller = UIAlertController(title: "“\(appName)“ Would Like to Access the Camera",
            message: "Allow to be able to take photos and videos.",
            preferredStyle: .alert)
        
        let dontAllow = UIAlertAction(title: "Don‘t Allow", style: .default, handler: nil)
        let okay = UIAlertAction(title: proxyAlertOkayText, style: .default, handler: nil)
        
        controller.addAction(dontAllow)
        controller.addAction(okay)
        controller.preferredAction = okay
        return controller
    }
    
    func findConfirmationButton(inAlertController alertController: UIAlertController) -> UIView? {
        if let label = findChildLabel(inView: alertController.view, withText: proxyAlertOkayText) {
            if let button = findButtonSuperview(forLabel: label) {
                return button
            }
        }
        return nil
    }
    
    func findChildLabel(inView view: UIView, withText text: String) -> UILabel? {
        let subviews = view.subviews
        
        for subview in subviews {
            if let label = subview as? UILabel {
                if label.text == text {
                    return label
                }
            }
            
            if let label = findChildLabel(inView: subview, withText: text) {
                return label
            }
        }
        
        return nil
    }
    
    func findButtonSuperview(forLabel label: UILabel) -> UIView? {
        let minimumWidth: CGFloat = 90
        var superViewMaybe = label.superview
        while let superview = superViewMaybe {
            if superview.frame.width >= minimumWidth {
                return superview
            }
            
            superViewMaybe = superview.superview
        }
        
        return nil
    }
}
