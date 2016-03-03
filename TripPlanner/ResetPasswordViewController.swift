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
     resets password
     */
    override func goNext() {
        HUD.show(.Progress)
        LoginDataStore.sharedInstance.resetPassword(emailField.textValue) { (error) -> () in
            PKHUD.sharedHUD.hide(animated: false, completion: nil)
            if let error = error {
                self.showErrorAlert(error.localizedDescription.stripCodeInfo)
            } else
            {
                self.showAlert("A reset link was sent to your email".localized)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    super.goNext()
                })
            }
        }
    }
    
    /**
     prepare for segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? LoginViewController {
            vc.presetEmail = emailField.textValue
        }
    }
    
}
