//
//  LoginDataStore.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/29/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase
import KeychainAccess

// keychain keys
let kEmailKey = "USER_EMAIL"

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
    
    /// user info
    var userInfo: User!
    
    /// secure storage
    private let keychain = Keychain(service: "com.toptal.TripPlanner")
    
    /// user info store
    private var userInfoStore: UserInfoStore?
    
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
                    let userInfo = ["name": name, "email": email, "role": UserRole.User.rawValue]
                    self.userInfo = User(dictionary: userInfo)
                    
                    // log user in
                    self.loginUser(email, password: password) { (uid, error) in
                        // add new user info
                        self.ref.childByAppendingPath("users").childByAppendingPath(uid).setValue(userInfo)
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
                // store credentials for restoring session
                self.keychain[kEmailKey] = email
                self.keychain[email] = password

                // wait until user info is loaded
                self.userInfoStore = UserInfoStore(uid: self.uid)
                if self.userInfo == nil {
                    self.userInfoStore?.onChange = { [unowned self] in
                        if let email = self.userInfoStore?.values["email"],
                            let role = self.userInfoStore?.values["role"],
                            let name = self.userInfoStore?.values["name"] {
                                let user = User()
                                user.email = email
                                user.role = UserRole(rawValue: role) ?? .User
                                user.name = name
                                user.key = authData.uid
                                self.userInfo = user
                                callback?(uid: authData.uid, nil)
                        }
                    }                    
                } else
                {
                    callback?(uid: authData.uid, nil)
                }
            }
        }
    }
    
    /**
     resets user password
    
     - parameter email:    email
     - parameter callback: callback
     */
    func resetPassword(email: String, callback: ((NSError?) -> ())?) {
        ref.resetPasswordForUser(email) { (error) -> Void in
            callback?(error)
        }
    }
    
    /**
     logs user out
     */
    func logout() {
        cleanCredentials()
        ref.unauth()
        userInfoStore = nil
        userInfo = nil
    }
    
    /**
     attempts to relogin using stored credentials
     
     - parameter callback: callback
     */
    func restoreSession(callback: ((uid: String?, NSError?) -> ())?) {
        if let email = keychain[kEmailKey],
            let password = keychain[email] {
            loginUser(email, password: password, callback: callback)
        } else
        {
            callback?(uid: nil, NSError(domain: "LOGIN", code: -1, userInfo: [NSLocalizedDescriptionKey: "No credentials present".localized]))
        }
    }

    /**
     checks if credentials are present
     
     - returns: true if credentials are present
     */
    func hasCredentials() -> Bool {
        return keychain[kEmailKey] != nil
    }
    
    /**
     cleans credentials
     */
    func cleanCredentials() {
        if let email = keychain[kEmailKey] {
            keychain[email] = nil
            keychain[kEmailKey] = nil
        }
    }
}
