//
//  FormViewController.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import UIComponents

/// text validation closure
typealias TextValidator = (String) -> Bool

/**
 * Base class for form screens with back & forth navigation
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class FormViewController: UIViewController {

    /// the segue triggered by next button
    var nextSegue: String {
        return "next"
    }
    
    /// validated fields
    private var fieldsToValidate: [(UITextField, String?, TextValidator)] = []
    
    /**
     adds a field for validation
     
     - parameter field:        textfield
     - parameter errorMessage: optional error message to show in case of fail
     - parameter validator:    validation check
     */
    func addFieldValidation(field: UITextField, errorMessage: String? = nil, validator: TextValidator) {
        fieldsToValidate.append(field, errorMessage, validator)
    }
    
    /**
     form validation
     
     - returns: validation result
     */
    func validate() -> (Bool, String?) {
        var result: (Bool, String?) = (true, nil)
        for (field, message, validator) in fieldsToValidate {
            if !validator(field.textValue) {
                result = (false, result.1 ?? message)
                if let field = field as? UnderlineTextField {
                    field.showError = true
                }
            }
        }
        return result
    }

    /**
    back tap handler
    
    - parameter sender: the button
    */
    @IBAction func backTapped(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     goes to next screen
     invoked after validation passes
     */
    func goNext() {
        self.performSegueWithIdentifier(nextSegue, sender: nil)
    }
    
    /**
     next tap handler
     
     - parameter sender: the button
     */
    @IBAction func nextTapped(sender: AnyObject?) {
        let (status, errorMessage) = self.validate()
        if status {
            goNext()
        } else
        {
            showAlert(errorMessage ?? "Please provide valid values for outlined fields")
        }
    }
}
