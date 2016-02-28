//
//  SignUpViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase

/**
 * Sign up screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class SignUpViewController: FormViewController {

    /// outlets
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addFieldValidation(fullName, validator: String.notEmpty..true)
        addFieldValidation(emailField, errorMessage: "Please provide valid email", validator: String.isEmail)
        addFieldValidation(usernameField, errorMessage: "Username must be at least 8 characters", validator: String.countNotLess..8)
        addFieldValidation(passwordField, errorMessage: "Password must be at least 8 characters", validator: String.countNotLess..8)
        
        // prefill data
        fullName.becomeFirstResponder()
    }

    /**
     sign user up
     */
    override func goNext() {
        
    }
    
}
