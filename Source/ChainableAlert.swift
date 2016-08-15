//
//  ChainableAlert.swift
//  ChainableAlert
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

/**
 *  Chainable use to show an alert.
 
 e.g.
 
 1.
 ChainableAlert
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
 ChainableAlert
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


public typealias AlertButtonAction = (ChainableAlert) -> Void
public typealias AlertTextFieldConfigurationHandler = (UITextField) -> Void

@available (iOS 8, *)
public class ChainableAlert {
    
    // Mark: init
    
    /**
     Create an alert
     */
    public static func alert(title title: String? = nil, message: String? = nil) -> ChainableAlert {
        return ChainableAlert(title: title, message: message, style: .Alert)
    }
    /**
     Create an action sheet
     */
    public static func actionSheet(title title: String? = nil, message: String? = nil) -> ChainableAlert {
        return ChainableAlert(title: title, message: message, style: .ActionSheet)
    }
    
    // Mark: add buttons
    
    /**
     Add a normal button to the alert
     */
    public func normalButton(title: String, handler: AlertButtonAction? = nil) -> ChainableAlert {
        let entity = AlertButtonEntity(title: title, action: handler == nil ? {_ in} : handler!)
        if normalEntities == nil {
            normalEntities = []
        }
        normalEntities?.append(entity)
        return self
    }
    
    /**
     Add a destructive button to the alert
     */
    public func destructiveButton(title: String, handler: AlertButtonAction? = nil) -> ChainableAlert {
        let entity = AlertButtonEntity(title: title, action: handler == nil ? {_ in} : handler!)
        if destructiveEntities == nil {
            destructiveEntities = []
        }
        destructiveEntities?.append(entity)
        return self
    }
    
    /**
     Add a cancel button to the alert, the most number of cancel button is 1
     */
    public func cancleButton(title: String, handler: AlertButtonAction? = nil) -> ChainableAlert {
        let entity = AlertButtonEntity(title: title, action: handler == nil ? {_ in} : handler!)
        cancleEntity = entity
        return self
    }
    
    /**
     Add a textField to the alert, if is action sheet, no use.
     */
    public func textField(configuration configuration: AlertTextFieldConfigurationHandler? = nil) -> ChainableAlert {
        guard style == .Alert else {
            return self
        }
        let handler = configuration == nil ? {_ in } : configuration!
        if textHandlers == nil {
            textHandlers = []
        }
        textHandlers?.append(handler)
        return self
    }
    
    /// textFields added to the alert.
    public var textFields: [UITextField]?
    
    // Mark: show
    
    /**
     Show the alert
     - parameter viewController: We will use it to present
     - parameter fromPosition:   If is action sheet, and device is iPad, we can set the source point for the popover controller
     */
    public func show(viewController: UIViewController? = nil, animated:Bool, fromPosition:(x: CGFloat, y: CGFloat)? = nil, completion: (() -> Void)? = nil) {
        let alertStyle: UIAlertControllerStyle = style == .Alert ? .Alert : .ActionSheet
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        
        if let entities = normalEntities {
            for entity in entities {
                let action = UIAlertAction(title: entity.title, style: .Default) { action in
                    let buttonAction = entity.action
                    buttonAction(self)
                }
                alertController.addAction(action)
            }
        }
        
        if let entities = destructiveEntities {
            for entity in entities {
                let action = UIAlertAction(title: entity.title, style: .Destructive) { action in
                    let buttonAction = entity.action
                    buttonAction(self)
                }
                alertController.addAction(action)
            }
        }
        
        if let entity = cancleEntity {
            let action = UIAlertAction(title: entity.title, style: .Cancel) { action in
                let buttonAction = entity.action
                buttonAction(self)
            }
            alertController.addAction(action)
        }
        
        if let textHandlers = textHandlers {
            for handler in textHandlers {
                alertController.addTextFieldWithConfigurationHandler(handler)
            }
            textFields = alertController.textFields
        }
        
        func showWithViewController(controller: UIViewController) {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = controller.view
                
                if let fromPosition = fromPosition {
                    popoverController.sourceRect = CGRect(x: fromPosition.x, y: fromPosition.y, width: 0, height: 0)
                } else {
                    let size = controller.view.bounds.size
                    popoverController.sourceRect = CGRect(x: size.width/2, y: size.height - 2, width: 0, height: 2)
                }
            }
            controller.presentViewController(alertController, animated: animated, completion: completion)
        }
        
        if let controller = viewController {
            showWithViewController(controller)
        } else if let controller = UIApplication.sharedApplication().keyWindow?.rootViewController {
            showWithViewController(controller)
        }
    }
    
    // Mark: private
    
    private var title: String?
    private var message: String?
    private var style: AlertStyle = .Alert
    
    private var normalEntities: [AlertButtonEntity]?
    private var destructiveEntities: [AlertButtonEntity]?
    private var cancleEntity: AlertButtonEntity?
    private var textHandlers: [AlertTextFieldConfigurationHandler]?
    
    private init(title: String?, message: String?, style: AlertStyle) {
        self.title = title
        self.message = message
        self.style = style
    }
    
}

// Mark: private

private enum AlertStyle : Int {
    case Alert
    case ActionSheet
}

private struct AlertButtonEntity {
    var title: String
    var action: AlertButtonAction
}

