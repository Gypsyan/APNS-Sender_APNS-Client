//
//  ShareViewController.swift
//  ShareMe
//
//  Created by Anantha Krishnan K G on 20/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        
        let userdefaults = UserDefaults.init(suiteName: "your group ID")
        userdefaults?.set(contentText, forKey: "pushToken")
        userdefaults?.synchronize()
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        return []
    }

}
