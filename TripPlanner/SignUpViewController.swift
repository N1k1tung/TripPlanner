//
//  SignUpViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import PKHUD

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
    @IBOutlet weak var passwordField: UITextField!
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addFieldValidation(fullName, validator: String.notEmpty..true)
        addFieldValidation(emailField, errorMessage: NSLocalizedString("Please provide valid email", comment: ""), validator: String.isEmail)
        addFieldValidation(passwordField, errorMessage: NSLocalizedString("Password must be at least 8 characters", comment: ""), validator: String.countNotLess..8)
    }
    
    /**
     view did appear
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fullName.becomeFirstResponder()
    }

    /**
     sign user up
     */
    override func goNext() {
        HUD.show(.Progress)
        LoginDataStore.sharedInstance.createUser(fullName.textValue, email: emailField.textValue, password: passwordField.textValue) { (uid, error) -> () in
            HUD.hide(afterDelay: 0, completion: nil)
            if let error = error {
                self.showErrorAlert(error.localizedDescription)
            } else
            {
                super.goNext()
            }
        }
    }
    
}
