//
//  UIViewController+ChainableAlert.swift
//  ChainableAlert
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

private var chainableAlert: ChainableAlert?

/**
 *  Add chainable use to show an alert.
 
 e.g.
 
 self.actionSheet("Title", message: "message")
 .normalButton("normal1")
 .normalButton("normal2")
 .normalButton("normal3") {
    print("normal3")
 }
 .destructiveButton("destructive1") {
    print("destructive1")
 }
 .destructiveButton("destructive2")
 .cancleButton("cancle")
 .show(animated: true)

 */
public extension UIViewController {
    
    /**
     Create alert, actually UIAlertView if the device is below iOS 8 or UIAlertController for iOS 8 and later
     */
    public func alert(titile: String?, message: String?) -> UIViewController {
        chainableAlert = ChainableAlert.alert(titile, message: message)
        return self
    }
    /**
     Create alert, actually UIActionSheet if the device is below iOS 8 or UIAlertController for iOS 8 and later
     */
    public func actionSheet(titile: String?, message: String?) -> UIViewController {
        chainableAlert = ChainableAlert.actionSheet(titile, message: message)
        return self
    }
    
    // Mark: add buttons
    
    /**
     Add a normal button to the alert
     */
    public func normalButton(title: String, handler: AlertButtonAction? = nil) -> UIViewController {
        chainableAlert?.normalButton(title, handler: handler)
        return self
    }
    
    /**
     Add a destructive button to the alert, we can add more than 1 for iOS 8 and later, BUT, if below iOS 8, this func will do nothing for alertView, and only one destructive button will added for actionSheet
     */
    public func destructiveButton(title: String, handler: AlertButtonAction? = nil) -> UIViewController {
        chainableAlert?.destructiveButton(title, handler: handler)
        return self
    }
    
    /**
     Add a cancel button to the alert, the most number of cancel button is 1
     */
    public func cancleButton(title: String, handler: AlertButtonAction? = nil) -> UIViewController {
        chainableAlert?.cancleButton(title, handler: handler)
        return self
    }
    
    // Mark: show
    
    /**
     Show the alert
     - parameter fromPosition:   If UIAlertController used, and style is action sheet, and device is iPad, we can set the source point for the popover controller
     - parameter animated:       If below iOS 8 , no use.
     - parameter completion:     If below iOS 8 , no use.
     */
    public func show(animated animated:Bool, fromPosition: (x: CGFloat, y: CGFloat)? = nil, completion: (() -> Void)? = nil) {
        if let alert = chainableAlert {
            alert.show(self, animated: animated, fromPosition: fromPosition) {
                completion?()
            }
        }
    }
}
