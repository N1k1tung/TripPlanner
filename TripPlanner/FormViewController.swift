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
        field.delegate = self
        field.tag = fieldsToValidate.count
        field.returnKeyType = .Done
        fieldsToValidate.last?.0.returnKeyType = .Next
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
            showAlert(errorMessage ?? "Please provide valid values for outlined fields".localized)
        }
    }
}

// MARK: - UITextFieldDelegate
extension FormViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == fieldsToValidate.count-1 {
            nextTapped(nil)
        } else
        {
            fieldsToValidate[textField.tag+1].0.becomeFirstResponder()
        }
        return false
    }
    
}