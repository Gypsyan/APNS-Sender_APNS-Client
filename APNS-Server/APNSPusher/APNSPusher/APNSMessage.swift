//
//  APNSMessage.swift
//  APNSPusher
//
//  Created by Anantha Krishnan K G on 20/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

public struct APNSMessage {
    // message
    public let alertBody:String
    public let title:String
    public let subTitle:String
    public let badge:Int
    
    public init(alertBody:String, title:String, subTitle:String, badge:Int) {
        self.alertBody = alertBody
        self.title = title
        self.subTitle = subTitle
        self.badge = badge
    }
}

