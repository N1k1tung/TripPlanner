//
//  User.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

/**
 * User info model
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class User: StoredObject {

    /// fields
    var name = ""
    var email = ""
    var role: UserRole = .User
    
    /**
     exports to dictionary
     
     - returns: dictionary
     */
    override func toDictionary() -> NSDictionary {
        return [
            "name": name,
            "email": email,
            "role": role.rawValue,
        ]
    }
    
    /**
     initializer from dictionary
     
     - parameter dictionary: dictionary
     */
    convenience init(dictionary: NSDictionary) {
        self.init()
        
        key = dictionary["key"] as? String
        email = dictionary["email"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        role = UserRole(rawValue: dictionary["role"] as? String ?? "") ?? .User
    }
    
}
