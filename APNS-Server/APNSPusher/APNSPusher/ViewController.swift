//
//  ViewController.swift
//  APNSPusher
//
//  Created by Anantha Krishnan K G on 20/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit

private var token:String?
class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var alertBody: UITextView!
    @IBOutlet var titleText: UITextField!
    @IBOutlet var subTitleText: UITextField!
    @IBOutlet var badgeText: UITextField!

    @IBOutlet var sendPushButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let userdefaults = UserDefaults.init(suiteName: APP_BUNDLE_GROUP_NAME)
        
        self.sendPushButton.isUserInteractionEnabled = true
        self.sendPushButton.backgroundColor = UIColor(colorLiteralRed: 39.0/255.0, green: 174.0/255.0, blue: 97.0/255.0, alpha: 1)
        guard let tokenValue = (userdefaults?.value(forKey: "pushToken")) else {
            print("Token is empty")
            shoWAlert(message: "No tokens. Please send token from pushAlert App", title: "Error !!")
            self.sendPushButton.isUserInteractionEnabled = false
            self.sendPushButton.backgroundColor = UIColor.gray
            return
        }
        token = tokenValue as? String
        
        if !(token!.isEmpty) {
            shoWAlert(message: token!, title: "your Token")
        }
    }
    
    func shoWAlert(message:String, title:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        let DestructiveAction = UIAlertAction(title: "Destructive", style: UIAlertActionStyle.destructive) {
            (result : UIAlertAction) -> Void in
            print("Destructive")
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func resetFields(_ sender: AnyObject) {
        
        self.titleText.text = ""
        self.subTitleText.text = ""
        self.alertBody.text = ""
        self.badgeText.text = ""
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        
        guard let tokenValue = token, let alert = self.alertBody.text, let subTitle = self.subTitleText.text, let title = self.titleText.text, let badge = self.badgeText.text else {
            print("SomeFields are empty OR Token is empty")
            return
        }
        
        let message = APNSMessage(alertBody:alert , title:title , subTitle:subTitle , badge: Int(badge)!)

        _ = try! APNSPushServer().sendPush(bundleId: PUSH_BUNDLE_ID, message: message, token: tokenValue, certPassWord: PUSH_CERT_PASSWORD, responseBlock: { (response) in
                 self.shoWAlert(message: response.serviceStatus.0.description, title: "APNS Response")
            self.resetFields(self)
            }, networkError: { (error) in
                self.shoWAlert(message: error.debugDescription, title: "Error !!!")
                self.resetFields(self)
        })

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}

