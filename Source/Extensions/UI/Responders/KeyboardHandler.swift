//
//  KeyboardHandler.swift
//  John Coates
//
//  Created by John Coates on 7/16/17.
//  Copyright © 2017 John Coates. All rights reserved.
//

import UIKit

@objc protocol KeyboardHandler {
    var scrollView: UIScrollView { get }
    
    @objc func keyboardWillShowNotification(_ notification: Notification)
    @objc func keyboardWillHideNotification(_ notification: Notification)
}

extension KeyboardHandler {
    
    func addKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShowNotification),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHideNotification),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        
    }
    
    func removeKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self,
                                          name: UIResponder.keyboardWillShowNotification,
                                          object: nil)
        
        notificationCenter.removeObserver(self,
                                          name: UIResponder.keyboardWillHideNotification,
                                          object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        guard let keyboardBounds = keyboardBounds(fromNotification: notification) else {
            return
        }
        
        // swiftlint:disable:next line_length
        // According to https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html
        // we should only use FrameEnd's size information and ignore the origin
        // however, we need to account for the bottom edge of the scroll view
        // not being the bottom edge of the screen
        let yPadding: CGFloat = 10
        let keyboardHeight = keyboardBounds.height + yPadding
        
        scrollView.contentInset.bottom = keyboardHeight
//        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
    }
    
    func keyboardWillHide(_ notificaion: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    func keyboardFrame(forView view: UIView, notification: Notification) -> CGRect? {
        guard let bounds = keyboardBounds(fromNotification: notification) else {
            return nil
        }
        
        let screenBounds = UIScreen.main.bounds
        var frame = bounds
        frame.origin.y = screenBounds.height - frame.height
        return view.convert(frame, from: nil)
    }
    
    private func keyboardBounds(fromNotification notification: Notification) -> CGRect? {
        guard let userInfo = notification.userInfo,
            let keyboardBoundsValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return nil
        }
        
        return keyboardBoundsValue.cgRectValue
    }
    
}
