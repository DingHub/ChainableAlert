# ChainableAlert
Chainable usage of Alert.<br>
---
We have a helper named ChainableAlert, and an extension of UIViewController to add chainable usage of alert.<br>
If the device is below iOS 8, UIAlertView or UIActionSheet will be used, else, UIAlertController will be used.<br>
Usage:
---
in view controller:
```
self.actionSheet(title: "Title", message: "message")
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
```
or
```
 ChainableAlert
 .alert(title: "Title", message: "message")
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
```
You can find an Objective-C version [HERE](https://github.com/DingHub/ChainableAlert-OC)


