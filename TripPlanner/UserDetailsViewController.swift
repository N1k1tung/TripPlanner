//
//  UserDetailsViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/4/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import PKHUD

/**
 * User details screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class UserDetailsViewController: FormViewController {

    /// data store
    var dataStore: UsersDataStore!
    
    /// user to edit
    var user: User!
    
    /// save handler
    var onSave: ((User) -> Void)?
    
    /// outlets
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userTripsSwitch: UISwitch!
    @IBOutlet weak var roleLabel: UILabel!
    
    /// is new flag
    var isNew = false
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addFieldValidation(fullName, validator: String.notEmpty..true)
        addFieldValidation(emailField, errorMessage: "Please enter valid email".localized, validator: String.isEmail)
        addFieldValidation(passwordField, errorMessage: "Password must be at least 8 characters".localized, validator: String.countNotLess..8)
        
        // update UI
        if let user = user {
            fullName.text = user.name
            // disable credentials editing
            passwordField.text = "xxxxxxxx"
            passwordField.enabled = false
            emailField.text = user.email
            emailField.enabled = false
            // only let admin view trips of others
            userTripsSwitch.enabled = LoginDataStore.sharedInstance.userInfo.role == .Admin
        } else
        {
            isNew = true
            user = User()
            userTripsSwitch.enabled = false
        }
        roleLabel.text = user.role.rawValue.localized
    }
    
    /**
     select role tap handler
     
     - parameter sender: the button
     */
    @IBAction func selectRoleTapped(sender: AnyObject) {
        
    }
    
    /**
     sign user up
     */
    override func goNext() {
        HUD.show(.Progress)
        LoginDataStore.sharedInstance.createUser(fullName.textValue, email: emailField.textValue, password: passwordField.textValue) { (uid, error) -> () in
            HUD.hide(afterDelay: 0, completion: nil)
            if let error = error {
                self.showErrorAlert(error.localizedDescription.stripCodeInfo)
            } else
            {
                self.fullName.text = ""
                self.emailField.text = ""
                self.passwordField.text = ""
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

}
