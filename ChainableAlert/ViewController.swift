//
//  ViewController.swift
//  ChainableAlert
//
//  Created by admin on 16/8/11.
//  Copyright © 2016年 Ding. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showAlert(_ sender: AnyObject) {
        self.alert(title: "Title", message: "message")
            .textField(configuration: { textField in
                textField.placeholder = "Username"
            })
            .textField(configuration: { textField in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            })
            .normalButton(title: "Login") { alert in
                if let textFields = alert.textFields {
                    print("Username:\(textFields[0].text!)\nPassword:\(textFields[1].text!)")
                }
            }
            .cancleButton(title: "cancle")
            .show(animated: true)
    }
}

