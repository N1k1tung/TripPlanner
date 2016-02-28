//
//  Configuration.swift
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright (c) 2016 Toptal. All rights reserved.
//

import UIKit

/**
* A helper class to get the configuration data in the plist file. All methods are self-explanatory.
*
* - author: Nikita Rodin
* - version: 1.0
*/
class Configuration: NSObject {
   
    // data
    var dict = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Configurations", ofType: "plist")!)
    
    // singleton
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
    
    // fake name
    class func fakeName() -> String {
        return self.sharedInstance.dict!["fakeName"] as! String
    }
    
    // fake email
    class func fakeEmail() -> String {
        return self.sharedInstance.dict!["fakeEmail"] as! String
    }
    
    // fake username
    class func fakeUsername() -> String {
        return self.sharedInstance.dict!["fakeUsername"] as! String
    }
    
    // fake password
    class func fakePassword() -> String {
        return self.sharedInstance.dict!["fakePassword"] as! String
    }

    
}
