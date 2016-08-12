# ChainableAlert
Chainable use of Alert.<br>
---
We have a class named ChainableAlert, and an extension of UIViewController to add chainable use of alert.<br>
If the device is below iOS 8, UIAlertView or UIActionSheet will be used, else, UIAlertController will be used.<br>
Usage:
---
in view controller:
```
self.actionSheet("Title", message: "message")
            .normalButton("normal1")
            .normalButton("normal2")
            .normalButton("normal3") {
                print("normal3")
            }
            .destructiveButton("destructive1")
            .destructiveButton("destructive2") {
                print("destructive2")
            }
            .cancleButton("cancle") {
                print("canceled")
            }
            .show(fromPosition: (20, 30),
                     animated: true) {
                        print("showd!")
        }
```
or
```
ChainableAlert
            .alert("Title", message: "message")
            .normalButton("normal1") {
                print("normal1")
            }
            .normalButton("normal2")
            .normalButton("normal3") {
                print("normal3")
            }
            .destructiveButton("destructive1") {
                print("destructive1")
            }
            .destructiveButton("destructive2") {
                print("destructive2")
            }
            .cancleButton("cancle") {
                print("canceled")
            }
            .show(animated: true) {
                    print("showd!")
        }
```


