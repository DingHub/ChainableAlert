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

    @IBAction func showAlert(sender: AnyObject) {
        
        self.alert(title: "Title", message: "message")
            .normalButton("normal1")
            .normalButton("normal2")
            .normalButton("normal3") {
                print("normal3")
            }
            .textField(configration: { textField in
                textField.placeholder = "Input your words~"
            })
            .destructiveButton("destructive1") {
                print("destructive1")
            }
            .destructiveButton("destructive2")
            .cancleButton("cancle")
            .show(animated: true)
        
    }
}

