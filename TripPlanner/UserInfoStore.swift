//
//  UserInfoStore.swift
//  TripPlanner
//
//  Created by Nikita Rodin on 3/4/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import UIKit
import Firebase

/**
 * Store to fetch user info
 *
 * - author: Nikita Rodin
 * - version: 1.0
 */
class UserInfoStore {

    /// user id
    let uid: String
    
    /// db ref
    private var ref: Firebase!
    
    /// values
    var values: [String: String] = [:]
    
    /// change handler
    var onChange: (() -> Void)?

    
    /**
     initializer
    
     - parameter uid: uid
     */
    init(uid: String) {
        self.uid = uid
        let firebaseURL = Configuration.firebaseURL()
        ref = Firebase(url:"\(firebaseURL)/users/\(uid)")
        
        // Retrieve new objects as they are added to Firebase
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            self.values[snapshot.key] = snapshot.value as? String
            self.onChange?()
        })
    }
    
    
}
