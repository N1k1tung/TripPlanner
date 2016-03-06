//
//  Configuration.swift
//  FirebaseWrapper
//
//  Created by Nikita Rodin on 3/5/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
* A helper class to get the configuration data in the plist file. All methods are self-explanatory.
*
* :author: Nikita Rodin
* :version: 1.0
*/
class Configuration: NSObject {
   
    /// data
    var dict = NSDictionary(contentsOfFile: NSBundle(forClass: Configuration.self).pathForResource("Configuration", ofType: "plist")!)
    
    /// singleton
    class var sharedInstance: Configuration {
    struct Static {
        static var instance: Configuration?
        static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Configuration()
        }
        
        return Static.instance!
    }

    /// base URL
    class var endpoint: String {
        return self.sharedInstance.dict!["endpoint"] as! String
    }

    /// log level
    class var logLevel: Int {
        return self.sharedInstance.dict!["logLevel"] as? Int ?? 1
    }
    
    /// access token
    class var firebaseAccessToken: String {
        return self.sharedInstance.dict!["firebaseAccessToken"] as! String
    }

    // MARK: - test data
    /// test UID
    class var testUID: String {
        return self.sharedInstance.dict!["testUID"] as! String
    }
    
    /// test trip ID
    class var testTripID: String {
        return self.sharedInstance.dict!["testTripID"] as! String
    }

    
}
