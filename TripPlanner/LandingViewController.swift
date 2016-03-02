//
//  LandingViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import PKHUD

/**
 * Landing screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class LandingViewController: UIViewController {
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove the line under navbar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        
        // check if we can relogin
        if LoginDataStore.sharedInstance.hasCredentials() {
            HUD.show(.LabeledProgress(title: "Signing in".localized, subtitle: nil))
            LoginDataStore.sharedInstance.restoreSession({ (uid, error) -> () in
                if let _ = error {
                    HUD.flash(.Error, withDelay: 0.5)
                } else
                {
                    HUD.flash(.Success, withDelay: 0.3)
                    self.performSegueWithIdentifier("restore", sender: nil)
                }
            })
        }
    }
        
}
