//
//  UIViewController+ChainableAlert.swift
//  ChainableAlert
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

/**
 *  Add chainable use to show an alert.
 
 e.g.
 
 1.
 self
 .actionSheet(title: "Title", message: "message")
 .normalButton("normal1")
 .normalButton("normal2")
 .normalButton("normal3") { alert in
    print("normal3")
 }
 .destructiveButton("destructive1") { alert in
    print("destructive1")
 }
 .destructiveButton("destructive2")
 .cancleButton("cancle") { alert in
    print("canceled")
 }
 .show(animated: true) {
    print("showd!")
 }

 2.
 self
 .alert(title: "Title", message: "message")
 .textField(configuration: { textField in
    textField.placeholder = "Username"
 })
 .textField(configuration: { textField in
 textField.placeholder = "Password"
    textField.secureTextEntry = true
 })
 .normalButton("Login") { alert in
    if let textFields = alert.textFields {
        print("Username:\(textFields[0].text!)\nPassword:\(textFields[1].text!)")
    }
 }
 .cancleButton("cancle")
 .show(animated: true)

 */

@available (iOS 8, *)
public extension UIViewController {
    
    /**
     Create an alert
     */
    public func alert(title: String? = nil, message: String? = nil) -> UIViewController {
        chainableAlert = ChainableAlert.alert(title: title, message: message)
        return self
    }
    /**
     Create an action sheet
     */
    public func actionSheet(title: String? = nil, message: String? = nil) -> UIViewController {
        chainableAlert = ChainableAlert.actionSheet(title: title, message: message)
        return self
    }
    
    // Mark: add buttons
    
    /**
     Add a normal button to the alert
     */
    public func normalButton(title: String, handler: AlertButtonAction? = nil) -> UIViewController {
        let _ = chainableAlert?.normalButton(title: title, handler: handler)
        return self
    }
    
    /**
     Add a destructive button to the alert
     */
    public func destructiveButton(title: String, handler: AlertButtonAction? = nil) -> UIViewController {
        let _ = chainableAlert?.destructiveButton(title: title, handler: handler)
        return self
    }
    
    /**
     Add a cancel button to the alert, the most number of cancel button is 1
     */
    public func cancleButton(title: String, handler: AlertButtonAction? = nil) -> UIViewController {
        let _ = chainableAlert?.cancleButton(title: title, handler: handler)
        return self
    }
    
    /**
     Add a textField to the alert, if is action sheet, no use.
     */
    public func textField(configuration: AlertTextFieldConfigurationHandler? = nil) -> UIViewController {
        let _ = chainableAlert?.textField(configuration: configuration)
        return self
    }
    
    // Mark: show
    
    /**
     Show the alert
     - parameter fromPosition:   If is action sheet, and device is iPad, we can set the source point for the popover controller
     */
    public func show(animated: Bool, fromPosition: (x: CGFloat, y: CGFloat)? = nil, completion: (() -> Void)? = nil) {
        if let alert = chainableAlert {
            alert.show(viewController: self, animated: animated, fromPosition: fromPosition) {
                completion?()
            }
        }
    }
}

private extension UIViewController {
    struct AssociatedKeys {
        static var chainableAlertKey = "chainableAlertKey"
    }
    var chainableAlert: ChainableAlert? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.chainableAlertKey) as? ChainableAlert)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.chainableAlertKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

