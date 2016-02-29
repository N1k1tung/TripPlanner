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
    static let sharedInstance = LoginDataStore()
    
    /// db ref
    private let ref: Firebase

    /// user id
    var uid: String = ""
    
    /**
     initializer
     */
    init() {
        let firebaseURL = Configuration.firebaseURL()
        ref = Firebase(url:"\(firebaseURL)")
    }
    
    /**
     creates account & authenticates user
     
     - parameter name:    full name
     - parameter email:    email
     - parameter password: password
     - parameter callback: callback
     */
    func createUser(name: String, email: String, password: String, callback: ((uid: String?, NSError?) -> ())?) {
        ref.createUser(email, password: password,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                    callback?(uid: nil, error)
                } else {
                    // log user in
                    self.loginUser(email, password: password) { (uid, error) in
                        if let uid = uid {
                            // add new user info
                            let userInfo = ["name": name, "email": email, "role": UserRole.User.rawValue]
                            self.ref.childByAppendingPath("users").childByAppendingPath(uid).setValue(userInfo)
                        }
                        callback?(uid: uid, error)
                    }
                }
        })
    }
    
    /**
     authenticates user
     
     - parameter email:    email
     - parameter password: password
     - parameter callback: callback
     */
    func loginUser(email: String, password: String, callback: ((uid: String?, NSError?) -> ())?) {
        ref.authUser(email, password: password) { (error, authData) -> Void in
            if error != nil {
                // There was an error authenticating the user
                callback?(uid: nil, error)
            } else {
                self.uid = authData.uid
                callback?(uid: authData.uid, nil)
            }
        }
    }
    
    /**
     logs user out
     */
    func logout() {
        ref.unauth()
    }
}
