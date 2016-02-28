//
//  LandingViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Landing screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class LandingViewController: UIViewController {

    /// sign up segue
    let signUpSegue = "signUp"
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove the line under navbar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
    }
    
    /**
     sign up tap handler
     
     - parameter sender: the button
     */
    @IBAction func signUpTapHandler(sender: AnyObject) {
        self.performSegueWithIdentifier(signUpSegue, sender: nil)
    }
    
    
}
