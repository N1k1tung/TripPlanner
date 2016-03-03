//
//  UsersDataStore.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/29/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase

// available user roles
enum UserRole: String {
    case User = "user"
    case Manager = "manager"
    case Admin = "admin"
}

/**
 * Firebase wrapper for users
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class UsersDataStore: ObjectStore {
    
    /// users
    var users: [User] {
        return objects as! [User]
    }
    
    /**
     ref constructor
     
     - returns: firebase ref
     */
    override func createRef() -> Firebase {
        let firebaseURL = Configuration.firebaseURL()
        return Firebase(url:"\(firebaseURL)/users")
    }
    
    
    /**
     object constructor
     
     - parameter dictionary: data dictionary
     
     - returns: stored object
     */
    override func createObject(dictionary: NSDictionary) -> StoredObject {
        return User(dictionary: dictionary)
    }
    
}