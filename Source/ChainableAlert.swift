//
//  ChainableAlert.swift
//  ChainableAlert
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

public typealias AlertButtonAction = () -> Void

/**
 *  Chainable use of alerts.
 
 e.g.

 ChainableAlert
 .alert("Title", message: "message")
 .normalButton("normal1")
 .normalButton("normal2")
 .normalButton("normal3") {
    print("normal3")
 }
 .destructiveButton("destructive1") {
    print("destructive1")
 }
 .destructiveButton("destructive2")
 .cancleButton("cancle") {
    print("canceled")
 }
 .show(animated: true) {
    print("showd!")
 }
 
 */
public class ChainableAlert {
    
    // Mark: init
    
    /**
     Create alert, actually UIAlertView if the device is below iOS 8 or UIAlertController for iOS 8 and later
     */
    public static func alert(titile: String?, message: String?) -> ChainableAlert {
        return ChainableAlert(title: titile, message: message, style: .Alert)
    }
    /**
     Create alert, actually UIActionSheet if the device is below iOS 8 or UIAlertController for iOS 8 and later
     */
    public static func actionSheet(titile: String?, message: String?) -> ChainableAlert {
        return ChainableAlert(title: titile, message: message, style: .ActionSheet)
    }
    
    // Mark: add buttons
    
    /**
     Add a normal button to the alert
     */
    public func normalButton(title: String, handler: AlertButtonAction? = nil) -> ChainableAlert {
        let entity = AlertButtonEntity(title: title, action: handler == nil ? {} : handler!)
        if normalEntities == nil {
            normalEntities = []
        }
        normalEntities?.append(entity)
        return self
    }
    
    /**
     Add a destructive button to the alert, we can add more than 1 for iOS 8 and later, BUT, if below iOS 8, this func will do nothing for alertView, and only one destructive button will added for actionSheet
     */
    public func destructiveButton(title: String, handler: AlertButtonAction? = nil) -> ChainableAlert {
        let entity = AlertButtonEntity(title: title, action: handler == nil ? {} : handler!)
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
        let entity = AlertButtonEntity(title: title, action: handler == nil ? {} : handler!)
        cancleEntity = entity
        return self
    }
    
    // Mark: show
    
    /**
     Show the alert
     - parameter viewController: If UIAlertController used, we will use it to present, and if UIActionSheet is used, it's view will be used
     - parameter fromPosition:   If UIAlertController used, and style is action sheet, and device is iPad, we can set the source point for the popover controller
     - parameter animated:       If below iOS 8 , no use.
     - parameter completion:     If below iOS 8 , no use.
     */
    public func show(viewController: UIViewController? = nil, animated:Bool, fromPosition:(x: CGFloat, y: CGFloat)? = nil, completion: (() -> Void)? = nil) {
        if #available(iOS 8.0, *) {
            let alertStyle: UIAlertControllerStyle = style == .Alert ? .Alert : .ActionSheet
            let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
            if let entities = normalEntities {
                for entity in entities {
                    let action = UIAlertAction(title: entity.title, style: .Default) { action in
                        let buttonAction = entity.action
                        buttonAction()
                    }
                    alertController.addAction(action)
                }
            }
            if let entities = destructiveEntities {
                for entity in entities {
                    let action = UIAlertAction(title: entity.title, style: .Destructive) { action in
                        let buttonAction = entity.action
                        buttonAction()
                    }
                    alertController.addAction(action)
                }
            }
            if let entity = cancleEntity {
                let action = UIAlertAction(title: entity.title, style: .Cancel) { action in
                    let buttonAction = entity.action
                    buttonAction()
                }
                alertController.addAction(action)
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
            
        } else {
            updateAlertButtonActions()
            if style == .Alert {
                let alertView = UIAlertView(title: title, message: message, delegate: AlertHelper.sharedHelper, cancelButtonTitle: cancleEntity?.title)
                if let entities = normalEntities {
                    for entity in entities {
                        alertView.addButtonWithTitle(entity.title)
                    }
                }
                alertView.show()
                
            } else {
                let actionSheet = UIActionSheet(title: title, delegate: AlertHelper.sharedHelper, cancelButtonTitle: cancleEntity?.title, destructiveButtonTitle: destructiveEntities?.first?.title)
                if let entities = normalEntities {
                    for entity in entities {
                        actionSheet.addButtonWithTitle(entity.title)
                    }
                }
                if let controller = viewController {
                    actionSheet.showInView(controller.view)
                } else if let controller = UIApplication.sharedApplication().keyWindow?.rootViewController {
                    actionSheet.showInView(controller.view)
                }
            }
        }
    }
    
    // Mark: private
    
    private var title: String?
    private var message: String?
    private var style: AlertStyle = .Alert
    
    private var normalEntities: [AlertButtonEntity]?
    private var destructiveEntities: [AlertButtonEntity]?
    private var cancleEntity: AlertButtonEntity?
    
    private init(title: String?, message: String?, style: AlertStyle) {
        self.title = title
        self.message = message
        self.style = style
    }
    
    private func updateAlertButtonActions() {
        alertButtonActions = []
        if self.style == .ActionSheet {
            if let buttonAction = destructiveEntities?.first?.action {
                alertButtonActions?.append(buttonAction)
            }
        }
        if let buttonAction = cancleEntity?.action {
            alertButtonActions?.append(buttonAction)
        }
        if let entities = normalEntities {
            for entity in entities {
                alertButtonActions?.append(entity.action)
            }
        }
    }
    
}

// Mark: private

private var alertButtonActions: [AlertButtonAction]? // for UIAlertViewDelegate and UIActionSheetDelegate

private enum AlertStyle : Int {
    case Alert
    case ActionSheet
}

private struct AlertButtonEntity {
    var title: String
    var action: AlertButtonAction
}


// Mark: helper class, for UIAlertViewDelegate and UIActionSheetDelegate
private class AlertHelper: NSObject, UIAlertViewDelegate, UIActionSheetDelegate {
    static let sharedHelper = AlertHelper()
    private override init() {}
    
    @objc func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        alertButtonActions?[buttonIndex]()
    }
    
    @objc func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        alertButtonActions?[buttonIndex]()
    }
}

