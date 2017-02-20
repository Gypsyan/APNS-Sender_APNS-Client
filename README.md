# APNS-Sender_APNS-Client

THis repo contains two apps , one is for registering push notification and another for sendin push notification to apns server

#APNS-Server - The APN Server app
 
 Follow the below steps to install the app,

 1. open the `APNS-Server/APNSPusher` app
 2. Go to the `target->APNSPusher` and set teh bundleID (Bundle Id should be added to the  grouping in apple developer account)
 3. set signing credentials
 4. Enable the `App Groups` in Capabilities. Please select the group name where your Bundle ID is added.

 5. Go to the  `target-> Shareme`.
 6. set Bundle Identifier annd signing credentials (the bundleId should be inside the same group as the `APNSPusher` bundle Id).
 7. In the capabilities enable the `App Groups`, and select the app group.

 8. open keychain and export your `push development iOS certificate` as p12.
 9. drag and drop the p12 file to the `APNSPusher/Cert` folder inside Xcode
 10. open the `APNSPusher/Utils` and go to `Constants.swift` file. give values for - `APP_BUNDLE_GROUP_NAME`, `PUSH_BUNDLE_ID`, `PUSH_CERT_NAME` and `PUSH_CERT_PASSWORD`.

 >Note: The `PUSH_BUNDLE_ID` field is teh bundle id of the second app (APNS-Client) that register for push notification.

11. Go to `ShareMe/ShareViewController.swift` and add your group Id value inside `let userdefaults = UserDefaults.init(suiteName: "your group ID")`

12. Build the app and run

Now we will go and setup the second app..

#APNS-Client - The client app

To run the client app do the following,

1. Open the `APNS-Client/pushAlert` app and add Bundle Id (same value you gave in `PUSH_BUNDLE_ID` in `PNS-Server` app )
2. add signing credentials 
3. Add `push notification`, `Background->Remote notification` and `background fetch` capabilities

4. Run your app and register for push notification.
5. it will ask you for sharing the token, select the `APNSPusher` from the list.


6. Now open the `APNSPusher` app. It will show you the shared token from `pushAlert` app.

7. type the message and perform send action. 

8. open the `APNSPusher` app the see the messages that came. the messages will be stored when th eapp is in teh background , and when you open the next time it will show you the recieved push message.



--------



## License
Copyright 2017 Ananth.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.