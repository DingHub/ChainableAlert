# ChainableAlert
Chainable usage of Alert.<br>
---
We have a helper named ChainableAlert, and an extension of UIViewController to add chainable usage of UIAlertController.<br>
Usage:
---
in view controller:
```
self.actionSheet(title: "Title", message: "message")
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

```
or an alert with textFeilds:
```
 self.alert(title: "Title", message: "message")
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

```

You can find an Objective-C version here: [ChainableAlert-OC](https://github.com/DingHub/ChainableAlert-OC)


