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
class UsersDataStore {

    /// singleton
    static let sharedInstance = UsersDataStore()
    
    /// db ref
    private let ref: Firebase

    /**
     initializer
     */
    init() {
        let firebaseURL = Configuration.firebaseURL()
        ref = Firebase(url:"\(firebaseURL)")
    }
}
