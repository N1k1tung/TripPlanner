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
class StoredObject: NSObject {

    /// fields
    var key: String?

    /**
     exports to dictionary
     
     - returns: dictionary
     */
    func toDictionary() -> NSDictionary {
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
    convenience init(dictionary: NSDictionary) {
        self.init()
        
        key = dictionary["key"] as? String
    }
    
}
