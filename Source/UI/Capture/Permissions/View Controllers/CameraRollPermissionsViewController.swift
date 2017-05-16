//
//  CameraRollPermissionsViewController.swift
//  Slate
//
//  Created by John Coates on 5/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit
import Cartography

fileprivate typealias LocalClass = CameraRollPermissionsViewController
class CameraRollPermissionsViewController: UIViewController {
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // init code
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class is not NSCoder compliant")
    }
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpViews()
    }
    
    // MARK: - Setup
    
    func setUpViews() {
        setUpDialog()
        setUpImageView()
        setUpExplanation()
        setUpButtons()
    }
    
    let dialog = RoundableView()
    func setUpDialog() {
        dialog.rounding = 0.05
        dialog.backgroundColor = UIColor.white
        view.addSubview(dialog)
        constrain(dialog) {
            let superview = $0.superview!
            $0.center == superview.center
            $0.width == 250
            $0.height >= 100
        }
    }
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "savePhotos"))
    func setUpImageView() {
        dialog.addSubview(imageView)
        constrain(imageView) {
            let superview = $0.superview!
            $0.top == superview.top + 23
            $0.centerX == superview.centerX
        }
    }
    
    let explanationLabel = UILabel()
    func setUpExplanation() {
        explanationLabel.text = "Would you like your photos saved to the Camera Roll, or would you like them saved in this app only?"
        explanationLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular)
        explanationLabel.textColor = UIColor(red:0.22, green:0.22, blue:0.22, alpha:1.00)
        explanationLabel.adjustsFontSizeToFitWidth = false
        explanationLabel.numberOfLines = 0
        explanationLabel.textAlignment = .center
        dialog.addSubview(explanationLabel)
        
        constrain(explanationLabel) {
            let superview = $0.superview!
            $0.width == superview.width * 0.9
            $0.centerX == superview.centerX
        }
        
        constrain(explanationLabel, imageView) { explanationLabel, imageView in
            explanationLabel.top == imageView.bottom + 24
        }
    }
    
    func setUpButtons() {
        let cameraRoll = generateButton(withText: "Save them to my Camera Roll",
                                        textColor: .white,
                                        buttonColor: UIColor(red:0.18, green:0.71,
                                                             blue:0.93, alpha:1.00))
        cameraRoll.setTappedCallback(instance: self, method: Method.tappedCameraRoll)
        
        let appOnly = generateButton(withText: "Save them in this app only",
                                        textColor: UIColor(red:0.10, green:0.67,
                                                           blue:0.94, alpha:1.00),
                                        buttonColor: UIColor(red:0.09, green:0.12,
                                                             blue:0.15, alpha:1.00))
        appOnly.setTappedCallback(instance: self, method: Method.tappedThisAppOnly)
        
        constrain(cameraRoll, appOnly, explanationLabel) { cameraRoll, appOnly, explanationLabel in
            let superview = cameraRoll.superview!
            cameraRoll.top == explanationLabel.bottom + 16
            appOnly.top == cameraRoll.bottom + 13
            superview.bottom >= appOnly.bottom + 19
        }
    }
    
    func generateButton(withText text: String,
                        textColor: UIColor,
                        buttonColor: UIColor) -> Button {
        let button = Button()
        button.backgroundColor = buttonColor
        button.rounding = 0.1
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        label.textColor = textColor
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
    
    // MARK: - User Interaction
    
    func tappedCameraRoll() {
        PermissionsWindow.dismiss()
    }
    
    func tappedThisAppOnly() {
        PermissionsWindow.dismiss()
    }
}

// MARK: - Callbacks

fileprivate struct Method {
    static let tappedCameraRoll = LocalClass.tappedCameraRoll
    static let tappedThisAppOnly = LocalClass.tappedThisAppOnly
    
}
