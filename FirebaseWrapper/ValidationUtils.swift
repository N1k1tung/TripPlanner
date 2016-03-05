//
//  ValidationUtils.swift
//  FirebaseWrapper
//
//  Created by Nikita Rodin on 3/5/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Validation utils
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
public class ValidationUtils {
    
    /**
     Check 'string' if it's correct ID.
     Delegates validation to two other methods.
     
     - parameter id:      the id string to check
     - parameter failure: the closure to invoke if validation fails
     
     - returns: true if string is not empty
     */
    public class func validateId(id: String, _ failure:FirebaseRequestFailureHandler?) -> Bool {
        if !ValidationUtils.validateStringNotEmpty(id, failure) { return false }
        if id.isNumber() && !ValidationUtils.validatePositiveNumber(id, failure) { return false }
        return true
    }
    
    /**
     Check array of strings if all are correct IDs.
     Delegates validation to other method.
     
     - parameter idd:     the list of id strings to check
     - parameter failure: the closure to invoke if validation fails
     
     - returns: true if all ids are correct
     */
    public class func validateIds(ids: [String]?, _ failure:FirebaseRequestFailureHandler?) -> Bool {
        if let ids = ids {
            for id in ids {
                if !validateId(id, failure) { return false }
            }
        }
        return true
    }
    
    /**
     Check 'string' if it's empty and callback failure if it is.
     
     - parameter string:  the string to check
     - parameter failure: the closure to invoke if validation fails
     
     - returns: true if string is not empty
     */
    public class func validateStringNotEmpty(string: String, _ failure:FirebaseRequestFailureHandler?) -> Bool {
        if string.isEmpty {
            failure?(NSError.FirebaseError("Empty string"))
            return false
        }
        return true
    }
    
    /**
     Check if the string is positive number and if not, then callback failure and return false.
     
     - parameter numberString: the string to check
     - parameter failure:      the closure to invoke if validation fails
     
     - returns: true if given string is positive number
     */
    public class func validatePositiveNumber(numberString: String,
        _ failure:FirebaseRequestFailureHandler?) -> Bool {
            if !numberString.isPositiveNumber() {
                failure?(NSError.FirebaseError("Incorrect number: \(numberString)"))
                return false
            }
            return true
    }
 
    /**
     Check trip if it has empty destination or wrong dates and callback failure if it has.
     
     - parameter dict:      the dictionary to check
     - parameter failure:   the closure to invoke if validation fails
     
     - returns: true if string is not empty
     */
    public class func validateTrip(trip: Trip?, _ failure:FirebaseRequestFailureHandler?) -> Bool {
        if trip == nil || trip!.destination == nil || trip!.startDate.compare(trip!.endDate) == .OrderedDescending {
            failure?(NSError.FirebaseError("Invalid Trip"))
            return false
        }
        return true
    }
    
    /**
     Check user if it has empty fields
     
     - parameter dict:      the dictionary to check
     - parameter failure:   the closure to invoke if validation fails
     
     - returns: true if string is not empty
     */
    public class func validateUser(user: User?, _ failure:FirebaseRequestFailureHandler?) -> Bool {
        if user == nil || user!.name.trim().isEmpty || !user!.email.isEmail() {
            failure?(NSError.FirebaseError("Invalid User Info"))
            return false
        }
        return true
    }
}