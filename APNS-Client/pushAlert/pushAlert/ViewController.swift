//
//  ViewController.swift
//  pushAlert
//
//  Created by Anantha Krishnan K G on 12/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    let notificationName = Notification.Name("NotificationIdentifierForToken")
    let notificationName2 = Notification.Name("NotificationIdentifierForRecieve")


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receivedNotification), name: notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.recievedPush), name:  NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    func recievedPush(notification: NSNotification) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let apnsMessage = appDelegate.apnsPush  {
            self.titleLabel.text = apnsMessage.title
            self.bodyLabel.text = apnsMessage.alertBody
            self.subTitleLabel.text = apnsMessage.subTitle

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func receivedNotification(notification: NSNotification)  {
        if let token = notification.userInfo?["token"] as? String {
           
            let activityViewController = UIActivityViewController(activityItems: [token], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            //activityViewController.excludedActivityTypes = [ UIActivityType.]
            self.present(activityViewController, animated: true, completion: nil)

        }
    }
    
    
    
}


