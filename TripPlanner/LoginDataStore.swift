//
//  LoginDataStore.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/29/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase

/**
 * Wrapper for login/sign up
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class LoginDataStore {

    
    /// singleton
    static let sharedInstance = UsersDataStore()
    
    /// db ref
    let ref: Firebase
    
    /**
     initializer
     */
    init() {
        let firebaseURL = Configuration.firebaseURL()
        ref = Firebase(url:"\(firebaseURL)/")
    }
}
