//
//  AppDelegate.swift
//  pushAlert
//
//  Created by Anantha Krishnan K G on 12/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import UserNotificationsUI
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var apnsPush:APNSMessage?
    
    let notificationName = Notification.Name("NotificationIdentifierForToken")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if( !(UIApplication.shared.isRegisteredForRemoteNotifications)){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            if(granted) {
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                print("Error while registering with APNS server :  \(error?.localizedDescription)")
            }
        })
        }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["token":token])
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = (((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary)
        
        apnsPush = APNSMessage(alertBody: payLoad.value(forKey: "body") as! String, title: payLoad.value(forKey: "title") as! String, subTitle: payLoad.value(forKey: "subtitle") as! String);
    }
}


