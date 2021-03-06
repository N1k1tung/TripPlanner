//
//  AppDelegate.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import IQKeyboardManagerSwift

/**
 * App delegate responder
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /**
     convenience typed singleton
     
     - returns: return shared app delegate casted to AppDelegate
     */
    class func sharedInstance() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Firebase.defaultConfig().persistenceEnabled = true
        PKHUD.sharedHUD.dimsBackground = false
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        // clean keychain of 1st launch
        if !NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch") {
            LoginDataStore.sharedInstance.cleanCredentials()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        // long keyboard loading fix
        #if DEBUG
            let tf = UITextField()
            window?.addSubview(tf)
            tf.becomeFirstResponder()
            tf.resignFirstResponder()
            tf.removeFromSuperview()
        #endif
        
        // Appearance
        UINavigationBar.appearance().tintColor = .blackColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.boldPoppinsFontOfSize(18)]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.poppinsFontOfSize(15)], forState: .Normal)
        
        return true
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

