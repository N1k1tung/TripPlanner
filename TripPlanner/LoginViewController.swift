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
     view did appear
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loginField.becomeFirstResponder()
    }
    
    /**
     logs user in
     */
    override func goNext() {
        HUD.show(.Progress)
        LoginDataStore.sharedInstance.loginUser(loginField.textValue, password: passwordField.textValue) { (uid, error) -> () in
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
