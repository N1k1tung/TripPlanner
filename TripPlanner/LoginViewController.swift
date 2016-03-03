//
//  LoginViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import UIComponents
import PKHUD
import Firebase

/**
 * sign in screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class LoginViewController: FormViewController {

    /// preset email
    var presetEmail = ""
    
    /// outlets
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addFieldValidation(loginField, errorMessage: "Please enter valid email".localized, validator: String.isEmail)
        addFieldValidation(passwordField, errorMessage: "Please enter password".localized, validator: String.notEmpty..false)
    }
    
    /**
     view did appear
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loginField.text = presetEmail
        loginField.becomeFirstResponder()
    }
    
    /**
     logs user in
     */
    override func goNext() {
        HUD.show(.Progress)
        LoginDataStore.sharedInstance.loginUser(loginField.textValue, password: passwordField.textValue) { (uid, error) -> () in
            PKHUD.sharedHUD.hide(animated: false, completion: nil)
            if let error = error {
                let err = FAuthenticationError(rawValue: error.code)
                if err == .UserDoesNotExist || err == .InvalidEmail || err == .InvalidPassword {
                    self.loginField.shake()
                    self.passwordField.shake()
                } else
                {
                    self.showErrorAlert(error.localizedDescription.stripCodeInfo)
                }
            } else
            {
                self.loginField.text = ""
                self.passwordField.text = ""
                super.goNext()
            }
        }
    }
    
    /**
     prepare for segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ResetPasswordViewController {
            vc.presetEmail = loginField.textValue
        }
    }
}
