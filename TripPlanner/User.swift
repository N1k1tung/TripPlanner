//
//  User.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/3/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit

// available user roles
public enum UserRole: String {
    case User = "user"
    case Manager = "manager"
    case Admin = "admin"
}

/**
 * User info model
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
public class User: StoredObject {

    /// fields
    public var name = ""
    public var email = ""
    public var role: UserRole = .User
    
    /**
     exports to dictionary
     
     - returns: dictionary
     */
    public override func toDictionary() -> [String: AnyObject] {
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
    public convenience init(dictionary: [String: AnyObject]) {
        self.init()
        
        key = dictionary["key"] as? String
        email = dictionary["email"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        role = UserRole(rawValue: dictionary["role"] as? String ?? "") ?? .User
    }
    
}
