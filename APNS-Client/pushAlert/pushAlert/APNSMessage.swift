//
//  APNSMessage.swift
//  pushAlert
//
//  Created by Anantha Krishnan K G on 20/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//


public struct APNSMessage {
    // message
    public let alertBody:String
    public let title:String
    public let subTitle:String
    
    public init(alertBody:String, title:String, subTitle:String) {
        self.alertBody = alertBody
        self.title = title
        self.subTitle = subTitle
    }
}
