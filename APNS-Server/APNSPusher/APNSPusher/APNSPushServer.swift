//
//  APNSPushServer.swift
//  APNSPusher
//
//  Created by Anantha Krishnan K G on 20/02/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import Security

open class APNSPushServer: NSObject {
    
    fileprivate var secIdentity:SecIdentity?
    static fileprivate var session:URLSession?
    public convenience override init() {
        self.init(session:nil)
    }
    public init(session:URLSession?) {
        super.init()
        guard let session = session else {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
            APNSPushServer.session = session
            return
        }
        APNSPushServer.session = session
    }
       
    public func sendPush(bundleId:String, message:APNSMessage, token:String, certPassWord:String,  responseBlock:((APNServiceResponse) -> ())?, networkError:((Error?)->())?) throws -> URLSessionDataTask? {
        
        let url = "https://api.development.push.apple.com:443/3/device/"+token
        var request = URLRequest(url: URL(string: url)!)
        
        guard let certId = getIdentityWith(certificatePath: Bundle.main.path(forResource: PUSH_CERT_NAME, ofType: "p12")!, passphrase: certPassWord) else {
            return nil
        }
        self.secIdentity = certId
        
        let messagePayload = createPaylod(message: message)
        
        let data = try JSONSerialization.data(withJSONObject: messagePayload, options: JSONSerialization.WritingOptions(rawValue: 0))
        request.httpBody = data
        request.httpMethod = "POST"
        request.addValue(bundleId, forHTTPHeaderField: "apns-topic")
        
        let task = APNSPushServer.session?.dataTask(with: request, completionHandler:{ (data, response, err) -> Void in
            
            guard err == nil else {
                networkError?(err)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                networkError?(err)
                return
            }
            
            let (statusCode, status) = APNServiceStatus.statusCodeFrom(response: response)
            let httpResponse = response
            let apnsId = httpResponse.allHeaderFields["apns-id"] as? String
            var responseStatus = APNServiceResponse(serviceStatus: (statusCode, status), serviceErrorReason: nil, apnsId: apnsId)
            
            guard status == .success else {
                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0))
                guard let js = json as? Dictionary<String,Any>,
                    let reason = js["reason"] as? String
                    else {
                        return
                }
                let serviceReason = APNServiceErrorReason(rawValue: reason)
                responseStatus.serviceErrorReason = serviceReason
                responseBlock?(responseStatus)
                return
            }
            responseStatus.apnsId = apnsId
            responseBlock?(responseStatus)
        })
        task?.resume()
        return task
        
        
        
    }
}

extension APNSPushServer: URLSessionDelegate, URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        var cert : SecCertificate?
        SecIdentityCopyCertificate(self.secIdentity!, &cert)
        let credentials = URLCredential(identity: self.secIdentity!, certificates: [cert!], persistence: .forSession)
        completionHandler(.useCredential,credentials)
    }
}

extension APNSPushServer {
    internal func getIdentityWith(certificatePath:String, passphrase:String) -> SecIdentity? {
        let PKCS12Data = try? Data(contentsOf: URL(fileURLWithPath: certificatePath))
        let key : String = kSecImportExportPassphrase as String
        let options = [key : passphrase]
        var items : CFArray?
        let ossStatus = SecPKCS12Import(PKCS12Data! as CFData, options as CFDictionary, &items)
        guard ossStatus == errSecSuccess else {
            return nil
        }
        let arr = items!
        if CFArrayGetCount(arr) > 0 {
            let newArray = arr as [AnyObject]
            let dictionary = newArray[0]
            let secIdentity = dictionary.value(forKey: kSecImportItemIdentity as String) as! SecIdentity
            return secIdentity
        }
        return nil
    }
    
    fileprivate func createPaylod(message:APNSMessage) -> Dictionary<String,Any> {
        
        return ["aps":["alert":["title":message.title,"subtitle":message.subTitle,"body":message.alertBody], "content-available":1,"badge":message.badge,"sound":"default"]];
    }
}
