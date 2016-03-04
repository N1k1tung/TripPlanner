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
        userTripsSwitch.on = user.key == LoginDataStore.sharedInstance.uid
        // can't unset user as currently displayed if selected already
        if userTripsSwitch.on {
            userTripsSwitch.enabled = false
        }
        roleLabel.text = user.role.rawValue.localized
    }
    
    /**
     select role tap handler
     
     - parameter sender: the button
     */
    @IBAction func selectRoleTapped(sender: UIButton) {
        endEditing()
        // manager can't change admin's role
        if user.role == .Admin && LoginDataStore.sharedInstance.userInfo.role != .Admin {
            return
        }
        
        let roles = LoginDataStore.sharedInstance.userInfo.role == .Admin ? [
            SimpleValue(title: UserRole.User.rawValue.localized, image: nil),
            SimpleValue(title: UserRole.Manager.rawValue.localized, image: nil),
            SimpleValue(title: UserRole.Admin.rawValue.localized, image: nil)
        ] : // manager can't create admins
        [
            SimpleValue(title: UserRole.User.rawValue.localized, image: nil),
            SimpleValue(title: UserRole.Manager.rawValue.localized, image: nil),
        ]
        let selectedRole = SimpleValue(title: roleLabel.text!, image: nil)
        UIPopoverController.showPopover("Role".localized, values: roles, selectedValue: selectedRole, fromRect: sender.frame, inView: sender.superview!) { (selected) -> Void in
            self.roleLabel.text = selected.title
        }
    }
    
    /**
     save tapped
     */
    override func goNext() {
        HUD.show(.Progress)
        user.name = fullName.textValue
        user.role = UserRole(rawValue: roleLabel.text!.lowercaseString) ?? .User
        if isNew {
            user.email = emailField.textValue
            // new user - create
            dataStore.createUser(user, password: passwordField.textValue) { (error) -> Void in
                HUD.hide(afterDelay: 0, completion: nil)
                if let error = error {
                    self.showErrorAlert(error.localizedDescription.stripCodeInfo)
                } else
                {
                    self.onSave?(self.user)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        } else
        {
            // existing - update
            self.dataStore.upsertObject(user, callback: { (error) -> Void in
                HUD.hide(afterDelay: 0, completion: nil)
                if let error = error {
                    self.showErrorAlert(error.localizedDescription.stripCodeInfo)
                } else
                {
                    self.onSave?(self.user)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
            // set as current user if needed
            if userTripsSwitch.enabled && userTripsSwitch.on {
                if let key = user.key {
                    LoginDataStore.sharedInstance.uid = key
                }
            }
        }
        
    }
    
    /**
     done tapped on last textfield
     */
    override func doneTapped() {
        self.endEditing()
    }

}
