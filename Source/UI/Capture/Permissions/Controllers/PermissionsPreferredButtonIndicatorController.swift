//
//  PermissionsPreferredButtonIndicatorController
//  Slate
//
//  Created by John Coates on 5/17/17.
//  Copyright © 2017 John Coates. All rights reserved.
//
// Controller for managing an arrow indicator that points at the preferred
// button for approving a permissions request

import UIKit

fileprivate typealias LocalClass = PermissionsPreferredButtonIndicatorController
class PermissionsPreferredButtonIndicatorController {
    
    // MARK: - Entry Points
    
    // Returns tear down block that must be called after permissions return
    static func attemptToPresentPreferredButtonIndicator(onViewController viewController: UIViewController,
                                                         permissionsRequest: @escaping () -> Void) {
        let indicatorController = LocalClass()
        
        guard let view = viewController.view else {
            fatalError("View controller is missing view")
        }
        
        indicatorController.retrievePreferredButtonFrame(targetView: view) { buttonFrame in
            if let buttonFrame = buttonFrame {
                let indicator = PermissionsButtonIndicatorViewController(buttonFrame: buttonFrame)
                viewController.present(indicator, animated: false, completion: {
                  permissionsRequest()
                })
            } else {
                permissionsRequest()
            }
        }
    }
    
    func retrievePreferredButtonFrame(targetView: UIView, completion: @escaping ButtonFrameCompletionBlock) {
        retrieveButtonFrameFromAlertProxy(targetView: targetView, completion: completion)
    }
    
    // MARK: - Alert Proxy
    
    let proxyAlertOkayText = "OK"
    var proxyWindow: UIWindow?
    
    typealias ButtonFrameCompletionBlock = (_ buttonFrame: CGRect?) -> Void
    
    private func retrieveButtonFrameFromAlertProxy(targetView: UIView,
                                                   completion: @escaping ButtonFrameCompletionBlock) {
        let presentingController = UIViewController()
        proxyWindow = createProxyWindow(withViewController: presentingController)
        
        let alertController = proxyAlertController()
        
        presentingController.present(alertController, animated: false, completion: {
            guard let confirmationButton = self.findConfirmationButton(inAlertController: alertController) else {
                self.tearDownAlertProxy()
                completion(nil)
                return
            }
            let buttonFrame = confirmationButton.convert(confirmationButton.frame, to: targetView)
            presentingController.dismiss(animated: false, completion: {
                self.tearDownAlertProxy()
                completion(buttonFrame)
            })
        })
    }
    
//    func showOkayButtonIndicator(withOkayButtonFrame buttonFrame: CGRect, after: @escaping ()->Void) {
//        let indicator = PermissionsButtonIndicatorViewController(buttonFrame: buttonFrame)
//        present(indicator, animated: false, completion: {
//            after()
//        })
//    }
    
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
