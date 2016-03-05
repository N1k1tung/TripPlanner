//
//  NSExtensions.swift
//  FirebaseWrapper
//
//  Created by Nikita Rodin on 3/5/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import Foundation

/**
 * helper String extensions
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
public extension String {
    
    /**
     Checks if the string is number
     
     - returns: true if the string presents number
     */
    public func isNumber() -> Bool {
        struct Static {
            static var formatter = NSNumberFormatter()
        }
        
        if let _ = Static.formatter.numberFromString(self) {
            return true
        }
        return false
    }
    
    /**
     Checks if the string is positive number
     
     - returns: true if the string presents positive number
     */
    public func isPositiveNumber() -> Bool {
        struct Static {
            static var formatter = NSNumberFormatter()
        }
        
        if let number = Static.formatter.numberFromString(self) {
            if number.doubleValue > 0 {
                return true
            }
        }
        return false
    }
    
    /**
     gets swift class name
     
     - parameter c: class
     
     - returns: class name
     */
    public static func stringFromClass(c: AnyClass) -> String {
        let className = NSStringFromClass(c).componentsSeparatedByString(".").last!
        return className
    }
    
}

/**
 * Parsing helper
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
public extension NSDate {
    
    /**
     parses date from string
     
     - parameter string: string
     
     - returns: date
     */
    public class func parse(string: String) -> NSDate? {
        struct Static {
            static var once: dispatch_once_t = 0
            static var df: NSDateFormatter! = nil
        }
        dispatch_once(&Static.once) {
            Static.df = NSDateFormatter()
            Static.df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            Static.df.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        }
        return Static.df.dateFromString(string)
    }
    
}