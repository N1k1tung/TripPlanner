//
//  LoginViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import UIComponents

/**
 * sign in screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class LoginViewController: FormViewController {

    /// outlets
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addFieldValidation(loginField, validator: String.notEmpty..true)
        addFieldValidation(passwordField, validator: String.notEmpty..false)
    }
    
    /**
     view will appear
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loginField.becomeFirstResponder()
    }
    
    /**
     form validation
     
     - returns: validation result
     */
    override func validate() -> (Bool, String?) {
        var (status, msg) = super.validate()
        if status {
            // MOCK check
            if loginField.textValue != Configuration.fakeUsername() || passwordField.textValue != Configuration.fakePassword() {
                status = false
                msg = "Incorrect username or password"
            }
        }
        return (status, msg)
    }
}
