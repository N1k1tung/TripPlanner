//
//  UsersDataStore.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 2/29/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase

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
    
    /**
     creates account & stores user info
     
     - parameter user:     user info
     - parameter password: password
     - parameter callback: callback
     */
    func createUser(user: User, password: String, callback: ((NSError?) -> Void)?) {
        ref.createUser(user.email, password: password,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                    callback?(error)
                } else {
                    if let uid = result["uid"] as? String {
                        user.key = uid
                        self.upsertObject(user, callback: callback)
                    }
                }
        })
    }
    
    /**
    Removes user
    
    - parameter user:     user
    - parameter password: password
    - parameter callback: callback
    */
    func removeUser(user: User, password: String, callback: ((NSError?) -> Void)?) {
        if let key = user.key {
            ref.removeUser(user.email, password: password, withCompletionBlock: { (error) -> Void in
                if let error = error {
                    callback?(error)
                } else
                {
                    // remove user info
                    self.removeObject(key, callback: callback)
                }
            })
        }
    }
    
}