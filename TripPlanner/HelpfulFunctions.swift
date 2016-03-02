//
//  HelpfulFunctions.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/27/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import Foundation

/**
A set of helpful functions and extensions
*/


/**
* Extenstion adds helpful methods to String
*
* @author Nikita Rodin
* @version 1.0
*/
extension String {
    
    /**
     Get string without spaces at the end and at the start.
     
     - returns: trimmed string
     */
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /**
     validates email
     
     - returns: true if self is a valid email
     */
    func isEmail() -> Bool {
        let email = self.trim()
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let regEx = try! NSRegularExpression(pattern: emailRegEx, options: .CaseInsensitive)
        let regExMatches: Int = regEx.numberOfMatchesInString(email, options: [], range: NSMakeRange(0, email.characters.count))
        return regExMatches > 0
    }
    
    /**
     validates email
     
     - parameter s: string
     
     - returns: validation check
     */
    static func isEmail(s: String) -> Bool {
        return s.isEmail()
    }
    
    /**
     Checks if string contains given substring
     
     - parameter substring:     the search string
     - parameter caseSensitive: flag: true - search is case sensitive, false - else
     
     - returns: true - if the string contains given substring, false - else
     */
    func contains(substring: String, caseSensitive: Bool = true) -> Bool {
        if let _ = self.rangeOfString(substring,
            options: caseSensitive ? NSStringCompareOptions(rawValue: 0) : .CaseInsensitiveSearch) {
                return true
        }
        return false
    }
    
    /**
     Shortcut method for stringByReplacingOccurrencesOfString
     
     - parameter target:     the string to replace
     - parameter withString: the string to add instead of target
     
     - returns: a result of the replacement
     */
    func replace(target: String, withString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString,
            options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    /**
     Checks if the string is number
     
     - returns: true if the string presents number
     */
    func isNumber() -> Bool {
        let formatter = NSNumberFormatter()
        if let _ = formatter.numberFromString(self) {
            return true
        }
        return false
    }
    
    /**
     Checks if the string is positive number
     
     - returns: true if the string presents positive number
     */
    func isPositiveNumber() -> Bool {
        let formatter = NSNumberFormatter()
        if let number = formatter.numberFromString(self) {
            if number.doubleValue > 0 {
                return true
            }
        }
        return false
    }

    /**
     convenience empty check
     
     - parameter trim: trim the whitespace before check
     
     - returns: true if string is not empty
     */
    func notEmpty(trim: Bool = true) -> Bool {
        return trim ? !self.trim().isEmpty : !self.isEmpty
    }
    
    /**
     convenience empty check
     
     - parameter s:    string
     - parameter trim: trim the whitespace before check
     
     - returns: true if string is not empty
     */
    static func notEmpty(s: String, trim: Bool = true) -> Bool {
        return s.notEmpty(trim)
    }
    
    /**
     convenience count check with trim
     
     - parameter s:     string
     - parameter count: min count
     
     - returns: true if string not less then count characters
     */
    static func countNotLess(s: String, count: Int = 8) -> Bool {
        return s.trim().characters.count >= count
    }
    
    
    /**
     gets swift class name
     
     - parameter c: class
     
     - returns: class name
     */
    static func stringFromClass(c: AnyClass) -> String {
        let className = NSStringFromClass(c).componentsSeparatedByString(".").last!
        return className
    }
    
    /// localized string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}

// MARK: - date formatters

/// default date formatter
var dateFormetter: NSDateFormatter = {
    let f = NSDateFormatter()
    f.locale = NSLocale.autoupdatingCurrentLocale()
    f.dateStyle = .MediumStyle
    f.timeStyle = .NoStyle
    return f
}()

/// date formatter for serializing
var requestDateFormetter: NSDateFormatter = {
    let f = NSDateFormatter()
    f.locale = NSLocale(localeIdentifier: "en_US")
    f.dateFormat = "dd-MM-yyyy"
    f.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    return f
}()

