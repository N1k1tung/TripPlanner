//
//  ResetPasswordViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import PKHUD

/**
 * Reset password screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class ResetPasswordViewController: FormViewController {

    /// preset email
    var presetEmail = ""
    
    /// outlets
    @IBOutlet weak var emailField: UITextField!
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addFieldValidation(emailField, errorMessage: "Please enter valid email".localized, validator: String.isEmail)
        emailField.text = presetEmail
        emailField.becomeFirstResponder()
    }

    /**
     resets passwor
     */
    override func goNext() {
        HUD.show(.Progress)
        LoginDataStore.sharedInstance.resetPassword(emailField.textValue) { (error) -> () in
            PKHUD.sharedHUD.hide(animated: false, completion: nil)
            if let error = error {
                self.showErrorAlert(error.localizedDescription)
            } else
            {
                self.showAlert("A reset link was sent to your email".localized)
                super.goNext()
            }
        }
    }
    
}
