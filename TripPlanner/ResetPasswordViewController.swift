//
//  ResetPasswordViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Reset password screen
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class ResetPasswordViewController: FormViewController {

    /// outlets
    @IBOutlet weak var emailField: UITextField!
    
    /**
     view did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addFieldValidation(emailField, errorMessage: NSLocalizedString("Please enter valid email", comment: ""), validator: String.isEmail)
        
        emailField.becomeFirstResponder()
    }

}
