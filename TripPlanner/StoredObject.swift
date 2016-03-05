//
//  StoredObject.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * Base class for stored in Firebase objects
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
public class StoredObject: NSObject {

    /// fields
    public var key: String?

    /**
     exports to dictionary
     
     - returns: dictionary
     */
    public func toDictionary() -> [String: AnyObject] {
        return [:]
    }
    
    /**
     empty initializer
     */
    override init() {
        super.init()
    }
    
    /**
     initializer from dictionary
     
     - parameter dictionary: dictionary
     */
    public convenience init(dictionary: [String: AnyObject]) {
        self.init()
        
        key = dictionary["key"] as? String
    }
    
}
